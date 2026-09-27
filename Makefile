.PHONY: generate build test test-kit test-ui

XCODEBUILD = xcodebuild -project SprygMac.xcodeproj -scheme SprygMac -destination 'platform=macOS'

generate:
	xcodegen generate

build: generate
	$(XCODEBUILD) build

test: test-kit test-ui

test-kit:
	cd SprygKit && swift test

test-ui: generate
	$(XCODEBUILD) test
