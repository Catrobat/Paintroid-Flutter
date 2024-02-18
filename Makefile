.PHONY: run pods-clean get clean build languages lint format test watch

FLUTTER := flutter
DART := dart

run:
	$(FLUTTER) run

pods-clean:
	rm -Rf ios/Pods ; \
	rm -Rf ios/.symlinks ; \
	rm -Rf ios/Flutter/Flutter.framework ; \
	rm -Rf ios/Flutter/Flutter.podspec ; \
	rm ios/Podfile ; \
	rm ios/Podfile.lock ; \

get:
	chmod +x ./setup_sdk.sh
	./setup_sdk.sh
	chmod +x ./setup_melos.sh
	./setup_melos.sh
	melos bootstrap

clean:
	melos clean

build:
	melos run build:all

languages:
	@cd packages/l10n ; \
	$(FLUTTER) gen-l10n
	@echo "-> Generated l10n"

lint:
	$(FLUTTER) analyze
	melos run lint:all

format:
	$(DART) format --set-exit-if-changed .

test:
	melos run test:all

test-unit:
	melos run test:unit

test-widget:
	melos run test:widget

watch:
	$(DART) run build_runner watch --delete-conflicting-outputs

melos:
	$(DART) pub global activate melos
	