.PHONY: build xcode

build:
	swift build --configuration=release -Xswiftc -static-stdlib

xcode:
	swift package generate-xcodeproj --xcconfig-overrides=Config.xcconfig