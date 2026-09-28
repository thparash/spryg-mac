.PHONY: generate build run run-fixtures test test-kit test-ui

XCODEBUILD = xcodebuild -project SprygMac.xcodeproj -scheme SprygMac -destination 'platform=macOS' -derivedDataPath DerivedData
APP = DerivedData/Build/Products/Debug/Spryg.app

generate:
	xcodegen generate

build: generate
	$(XCODEBUILD) build

# Launch the Debug build against the production API.
run: build
	open -n $(APP)

# Launch with canned responses: any email and password signs in.
run-fixtures: build
	open -n $(APP) --args -SprygUseFixtures YES

test: test-kit test-ui

test-kit:
	cd SprygKit && swift test

test-ui: generate
	$(XCODEBUILD) test
