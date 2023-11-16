.PHONY: pubget build watch clean test analyze test-unit test-widget test-all all

clean:
	flutter clean

pubget:
	flutter pub get

build:
	dart run build_runner build --delete-conflicting-outputs

run:
	flutter run

all: clean pubget build run

watch:
	dart run build_runner watch --delete-conflicting-outputs

analyze:
	flutter analyze

test-unit:
	flutter test test/unit

test-widget:
	flutter test test/widget

test-all:
	flutter test
