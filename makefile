FLUTTER := fvm flutter

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
	$(FLUTTER) pub get
	melos bootstrap

build-runner:
	melos run build:all

languages:
	@cd packages/l10n ; \
	$(FLUTTER) gen-l10n
	@echo "-> Generated l10n"

lint:
	melos run lint:all

format:
	dart format --set-exit-if-changed .

clean:
	melos clean

testing:
	$(FLUTTER) test
	melos run test:all