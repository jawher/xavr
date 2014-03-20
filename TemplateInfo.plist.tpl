<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Kind</key>
	<string>Xcode.Xcode3.ProjectTemplateUnitKind</string>
	<key>Identifier</key>
	<string>jawher.xavr.xcode4.template</string>
	<key>Concrete</key>
	<true/>
	<key>Description</key>
	<string>This template builds an basic AVR C project</string>
	<key>SorterOrder</key>
	<integer>1</integer>
	<key>Platforms</key>
	<array>
		<string>com.apple.platform.macosx</string>
	</array>
	<key>AllowedTypes</key>
	<array>
		<string>public.c-header</string>
		<string>public.c-source</string>
	</array>
	<key>Ancestors</key>
	<array>
		<string>com.apple.dt.unit.base</string>
	</array>
	<key>Definitions</key>
	<dict>
		<key>main.c</key>
		<dict>
			<key>Path</key>
			<string>main.c</string>
		</dict>
		<key>Makefile</key>
		<dict>
			<key>Path</key>
			<string>Makefile</string>
			<key>Group</key>
			<array>
				<string>Makefiles</string>
			</array>
		</dict>
	</dict>
	<key>Nodes</key>
	<array>
		<string>main.c</string>
		<string>Makefile</string>
	</array>
	<key>Project</key>
	<dict>
		<key>Configurations</key>
		<dict>
			<key>Debug</key>
			<dict/>
			<key>Release</key>
			<dict/>
		</dict>
		<key>SharedSettings</key>
		<dict>
			<key>PATH</key>
			<string>$(PATH):$(PROJECT_DIR)</string>
			<key>HEADER_SEARCH_PATHS</key>
			<string>{isystem}</string>
			<key>PRODUCT_NAME</key>
			<string>$(TARGET_NAME)</string>
		</dict>
	</dict>
	<key>Targets</key>
	<array>
		<dict>
			<key>Name</key>
			<string>All</string>
			<key>BuildToolPath</key>
			<string>make</string>
			<key>TargetType</key>
			<string>Legacy</string>
			<key>BuildToolArgsString</key>
			<string>all -C &quot;$(PROJECT)&quot;</string>
		</dict>
		<dict>
			<key>Name</key>
			<string>Build</string>
			<key>TargetType</key>
			<string>Legacy</string>
			<key>BuildToolPath</key>
			<string>make</string>
			<key>BuildToolArgsString</key>
			<string>clean build -C &quot;$(PROJECT)&quot;</string>
		</dict>
		<dict>
			<key>Name</key>
			<string>Upload</string>
			<key>TargetType</key>
			<string>Legacy</string>
			<key>BuildToolPath</key>
			<string>make</string>
			<key>BuildToolArgsString</key>
			<string>clean build program -C &quot;$(PROJECT)&quot;</string>
		</dict>
		<dict>
			<key>Name</key>
			<string>Clean</string>
			<key>TargetType</key>
			<string>Legacy</string>
			<key>BuildToolPath</key>
			<string>make</string>
			<key>BuildToolArgsString</key>
			<string>clean -C &quot;$(PROJECT)&quot;</string>
		</dict>
		<dict>
			<key>ProductType</key>
			<string>com.apple.product-type.tool</string>
			<key>Name</key>
			<string>Index</string>
			<key>Configurations</key>
			<dict>
				<key>Debug</key>
				<dict/>
				<key>Release</key>
				<dict/>
			</dict>
			<key>BuildPhases</key>
			<array>
				<dict>
					<key>Class</key>
					<string>Sources</string>
				</dict>
			</array>
		</dict>
	</array>
	<key>Options</key>
	<array>
		<dict>
			<key>Default</key>
			<string>atmega328p</string>
			<key>Description</key>
			<string>Microcontroller</string>
			<key>Identifier</key>
			<string>MCU</string>
			<key>Name</key>
			<string>MCU</string>
			<key>SortOrder</key>
			<integer>1</integer>
			<key>Type</key>
			<string>popup</string>
			<key>Units</key>
			<dict>
				


				@iter mcus@
				<key>{mcu}</key>
				<dict>
					<key>Project</key>
					<dict>
						<key>Configurations</key>
						<dict>
							<key>Debug</key>
							<dict>
							<key>GCC_PREPROCESSOR_DEFINITIONS</key>
								<string>DEBUG=1, {defi}, F_CPU=___VARIABLE_F_CPU___</string>
							</dict>
							<key>Release</key>
							<dict>
								<key>GCC_PREPROCESSOR_DEFINITIONS</key>
								<string>{defi}, F_CPU=___VARIABLE_F_CPU___</string>
							</dict>
						</dict>
					</dict>
				</dict>
				
				@end@


			</dict>
		</dict>


		<dict>
			<key>Default</key>
			<string>arduino</string>
			<key>Description</key>
			<string>Programmer</string>
			<key>Identifier</key>
			<string>PROGRAMMER</string>
			<key>Name</key>
			<string>Programmer</string>
			<key>SortOrder</key>
			<integer>2</integer>
			<key>Type</key>
			<string>popup</string>
			<key>Units</key>
			<dict>
				@iter programmers@
				<key>{programmer}</key>
				<dict/>
				@end@
			</dict>
		</dict>

		<dict>
			<key>Default</key>
			<string>16000000</string>
			<key>Description</key>
			<string>MCU frequence (in Hz)</string>
			<key>Identifier</key>
			<string>F_CPU</string>
			<key>Name</key>
			<string>Frequency</string>
			<key>SortOrder</key>
			<integer>3</integer>
			<key>Required</key>
        	<true/>
			<key>Type</key>
			<string>text</string>
		</dict>

		<dict>
			<key>Default</key>
			<string>{avr_loc}</string>
			<key>Description</key>
			<string>AVR GCC directory</string>
			<key>Identifier</key>
			<string>AVR_LOC</string>
			<key>Name</key>
			<string>AVR GCC directory</string>
			<key>SortOrder</key>
			<integer>4</integer>
			<key>Required</key>
        	<true/>
			<key>Type</key>
			<string>static</string>
		</dict>
	</array>
</dict>
</plist>
