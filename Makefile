.PHONY: get build watch clean test analyze test-unit test-widget test-all all

clean:
	flutter clean

get:
	flutter pub get

run:
	flutter run

all: clean get build run

watch:
	dart run build_runner watch --delete-conflicting-outputs

lint:
	flutter analyze

build:
	dart run build_runner build --delete-conflicting-outputs

analyze:
	flutter analyze

test-unit:
	flutter test test/unit

test-widget:
	flutter test test/widget

test:
	flutter test

sort:
	dart run import_sorter:main