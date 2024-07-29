.PHONY: get build watch clean test analyze test-unit test-widget test-all all fvm_check

# Check if FVM is installed
FVM_PRESENT := $(shell command -v fvm 2> /dev/null)

# Use fvm if installed; otherwise use flutter directly
FLUTTER_CMD := $(if $(FVM_PRESENT),fvm flutter,flutter)
DART_CMD := $(if $(FVM_PRESENT),fvm dart,dart)

INTEGRATION_TEST_DIR=test/integration
DRIVER_FILE=$(INTEGRATION_TEST_DIR)/driver/driver.dart
DART_DEFINE_ARGS=

ifdef id
DART_DEFINE_ARGS += --dart-define=id=$(id)
endif

clean:
	$(FLUTTER_CMD) clean
	
get:
	$(FLUTTER_CMD) pub get

run:
	$(FLUTTER_CMD) run

all: clean get build run

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

integration:
ifeq ($(strip $(target)),)
	$(FLUTTER_CMD) test $(INTEGRATION_TEST_DIR)
else
	$(FLUTTER_CMD) test $(INTEGRATION_TEST_DIR)/$(target)_test.dart $(DART_DEFINE_ARGS)
endif

integration-drive:
ifeq ($(strip $(target)),)
	find $(INTEGRATION_TEST_DIR) -name '*_test.dart' | while read test_file; do \
		flutter drive --driver=$(DRIVER_FILE) --target=$$test_file $(DART_DEFINE_ARGS); \
	done
else
	flutter drive --driver=$(DRIVER_FILE) --target=$(INTEGRATION_TEST_DIR)/$(target)_test.dart $(DART_DEFINE_ARGS)
endif

test: $(FLUTTER_CMD) test

fvm_check:
	@echo Using $(FLUTTER_CMD) and $(DART_CMD) based on availability of FVM

