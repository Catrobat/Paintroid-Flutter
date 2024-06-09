.PHONY: get build watch clean test analyze test-unit test-widget test-all all fvm_check

# Check if FVM is installed
FVM_PRESENT := $(shell command -v fvm 2> /dev/null)

# Use fvm if installed; otherwise use flutter directly
FLUTTER_CMD := $(if $(FVM_PRESENT),fvm flutter,flutter)
DART_CMD := $(if $(FVM_PRESENT),fvm dart,dart)
PACKAGES_DIR := packages



clean:
	$(FLUTTER_CMD) clean

get:
	$(FLUTTER_CMD) pub get
	@for dir in $(shell find $(PACKAGES_DIR) -maxdepth 1 -type d); do \
        if [ "$$dir" != "$(PACKAGES_DIR)" ]; then \
            echo "Running $(FLUTTER_CMD) pub get in $$dir"; \
            (cd $$dir && $(FLUTTER_CMD) pub get); \
        fi \
    done

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

unit:
	$(FLUTTER_CMD) test test/unit

widget:
	$(FLUTTER_CMD) test test/widget

target ?= all
integration:
	@if [ "$(target)" = "all" ]; then \
		find integration_test -type f -name '*_test.dart' -print0 | xargs -0 -n1 -I {} flutter test {}; \
	else \
		FILE_PATH=$$(find integration_test -type f -name "$(target).dart"); \
		if [ -z "$$FILE_PATH" ]; then \
			echo "Test file $(target) not found."; \
			exit 1; \
		else \
			flutter test $$FILE_PATH; \
		fi \
	fi

test: unit widget integration

sort:
	$(DART_CMD) run import_sorter:main

fvm_check:
	@echo Using $(FLUTTER_CMD) and $(DART_CMD) based on availability of FVM

