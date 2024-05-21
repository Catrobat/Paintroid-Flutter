.PHONY: get build watch clean test analyze test-unit test-widget test-all all fvm_check

# Check if FVM is installed
FVM_PRESENT := $(shell command -v fvm 2> /dev/null)

# Use fvm if installed; otherwise use flutter directly
FLUTTER_CMD := $(if $(FVM_PRESENT),fvm flutter,flutter)
DART_CMD := $(if $(FVM_PRESENT),fvm dart,dart)

clean:
	$(FLUTTER_CMD) clean
	
get:
	$(FLUTTER_CMD) pub get

run:
	$(FLUTTER_CMD) run

all: clean get build sort run

watch:
	$(DART_CMD) run build_runner watch --delete-conflicting-outputs

lint:
	$(FLUTTER_CMD) analyze

build:
	$(DART_CMD) run build_runner build --delete-conflicting-outputs

analyze:
	$(FLUTTER_CMD) analyze

test-unit:
	$(FLUTTER_CMD) test test/unit

test-widget:
	$(FLUTTER_CMD) test test/widget

test-integration:
	flutter test test/integration

test:
	$(FLUTTER_CMD) test

sort:
	$(DART_CMD) run import_sorter:main

test-integration-drive:
	flutter drive --driver=test/integration/tools/driver.dart --target=test/integration/tools/line_tool_test.dart

fvm_check:
	@echo Using $(FLUTTER_CMD) and $(DART_CMD) based on availability of FVM

