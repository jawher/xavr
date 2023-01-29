import errno
import os
import re
import shutil
import string
import subprocess
import sys

ITER_BEGIN = re.compile('\s*@iter\s+(.+?)@\s*')
ITER_END = re.compile('\s*@end@\s*')


def exec_iter(items, template, output):
    lines = []
    for line in template:
        m = ITER_END.match(line)
        if m:
            break
        else:
            lines.append(line)

    for item in items:
        for line in lines:
            output.write(line.format(**item))


def exec_template(from_template, to, model):
    with open(from_template, 'r') as template:
        with open(to, 'w') as output:
            for line in template:
                m = ITER_BEGIN.match(line)
                if m:
                    items = model[m.group(1)]
                    exec_iter(items, template, output)
                else:
                    output.write(line.format(**model))


ISYS = '#include <...> search starts here:'


def mcu_to_def(mcu):
    defi = mcu.upper()
    families = ['XMEGA', 'MEGA', 'TINY']
    for family in families:
        defi = defi.replace(family, family.lower())
    return '__AVR_' + defi + '__'


def supported_mcus():
    HEADER = 'Known MCU names:'

    proc = subprocess.Popen('avr-gcc --target-help', stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                            shell=True)
    out, err = proc.communicate()
    lines = out.decode('utf-8').split('\n')

    mcus = []
    consider = False
    for line in lines:
        print(line)
        if HEADER in line:
            consider = True
        elif consider:
            if line.startswith(' '):
                for mcu in line.split():
                    mcus.append({'mcu': mcu, 'defi': mcu_to_def(mcu)})
            else:
                break

    return mcus


def supported_programmers():
    HEADER = 'Valid programmers are:'
    PROG_LINE = re.compile('  (.+?)\s+=.*')

    proc = subprocess.Popen('avrdude -c?', stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    out, err = proc.communicate()
    lines = err.decode('utf-8').split('\n')

    programmers = []
    consider = False
    for line in lines:
        if line == HEADER:
            consider = True
        elif consider:
            m = PROG_LINE.match(line)
            if m:
                programmers.append({'programmer': m.group(1)})
            else:
                break

    return programmers


def avr_loc():
    bin_path = subprocess.check_output('which avr-gcc', shell=True).strip()
    return os.path.dirname(os.path.dirname(os.path.realpath(bin_path)))


def avrdude_loc():
    return subprocess.check_output('which avrdude', shell=True).strip()


def isystem():
    proc = subprocess.Popen('echo | avr-cpp -v', stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    out, err = proc.communicate()

    lines = err.decode('utf-8').split('\n')
    isys = []

    consider = False
    for line in lines:
        if line == ISYS:
            consider = True
        elif consider:
            if line.startswith(' '):
                isys.append(os.path.normpath(line.strip()))
            else:
                break

    return isys


def ensure_installed(tool):
    proc = subprocess.Popen('which ' + tool, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    out, err = proc.communicate()
    out = out.decode('utf-8').strip()
    exitcode = proc.returncode
    if exitcode == 0:
        print('Found {t} install in "{p}"'.format(t=tool, p=out))
        return out
    else:
        print(tool + ' is not installed (or is not in the PATH). Exiting')
        sys.exit(1)


def mkdirs_p(dirs):
    try:
        os.makedirs(dirs)
    except OSError as e:
        if e.errno == errno.EEXIST:
            pass
        else:
            raise


def main():
    model = {}
    tools = ['avr-gcc', 'avr-g++', 'avr-objcopy', 'avr-objdump', 'avr-size', 'avr-nm', 'avrdude']
    for tool in tools:
        model[tool + '_loc'] = ensure_installed(tool)

    exec_template('Makefile.tpl', 'Makefile', model)

    model = {'isystem': ' '.join(isystem()),
             'mcus': supported_mcus(),
             'programmers': supported_programmers()
             }
    exec_template('TemplateInfo.plist.tpl', 'TemplateInfo.plist', model)

    print('Generated template:\n\tMCUs        : {}\n\tProgrammers : {}'
          .format(len(model['mcus']), len(model['programmers'])))

    DEST_DIR = os.path.join(os.path.expanduser('~'),
                            'Library/Developer/Xcode/Templates/Project Template/xavr/xavr.xctemplate/')
    print('Installing template in: "{}"'.format(DEST_DIR))
    mkdirs_p(DEST_DIR)
    shutil.copy('main.c', DEST_DIR)
    shutil.copy('Makefile', DEST_DIR)
    shutil.copy('TemplateInfo.plist', DEST_DIR)
    shutil.copy('TemplateIcon.icns', DEST_DIR)

    os.remove('Makefile')
    os.remove('TemplateInfo.plist')
    print('Done. Hack away !\n')


if __name__ == '__main__':
    main()
