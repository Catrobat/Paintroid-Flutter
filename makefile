FLUTTER := fvm flutter
PACKAGES := $(wildcard packages/*)
FEATURES := $(wildcard packages/features/*)
BUILD-RUNNER := packages/fav_qs_api packages/key_value_storage

run:
	$(FLUTTER) run

crun:
	clear
	$(FLUTTER) run

print:
	for feature in $(FEATURES); do \
		echo $${feature} ; \
	done
	for package in $(PACKAGES); do \
		echo $${package} ; \
	done

pods-clean:
	rm -Rf ios/Pods ; \
	rm -Rf ios/.symlinks ; \
	rm -Rf ios/Flutter/Flutter.framework ; \
	rm -Rf ios/Flutter/Flutter.podspec ; \
	rm ios/Podfile ; \
	rm ios/Podfile.lock ; \

get:
	$(FLUTTER) pub get
	for feature in $(FEATURES); do \
		cd $${feature} ; \
		echo "Updating dependencies on $${feature}" ; \
		$(FLUTTER) pub get ; \
		cd ../../../ ; \
	done
	for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Updating dependencies on $${package}" ; \
		$(FLUTTER) pub get ; \
		cd ../../ ; \
	done

freezze:
	$(FLUTTER) pub run build_runner build --delete-conflicting-outputs
	for feature in $(FEATURES); do \
		cd $${feature} ; \
		echo "Updating dependencies on $${feature}" ; \
		$(FLUTTER) pub run build_runner build --delete-conflicting-outputs ; \
		cd ../../../ ; \
	done
	for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Updating dependencies on $${package}" ; \
		$(FLUTTER) pub run build_runner build --delete-conflicting-outputs ; \
		cd ../../ ; \
	done

build-runner:
	for feature in $(FEATURES); do \
		cd $${feature} ; \
		echo "Running build-runner on $${feature}" ; \
		$(FLUTTER) pub run build_runner build --delete-conflicting-outputs ; \
		cd ../../../ ; \
	done
	for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Running build-runner on $${package}" ; \
		$(FLUTTER) pub run build_runner build --delete-conflicting-outputs ; \
		cd ../../ ; \
	done

languages:
	$(FLUTTER) gen-l10n
	for feature in $(FEATURES); do \
		cd $${feature} ; \
		echo "Updating dependencies on $${feature}" ; \
		$(FLUTTER) gen-l10n ; \
		cd ../../../ ; \
	done
	for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Updating dependencies on $${package}" ; \
		$(FLUTTER) gen-l10n ; \
		cd ../../ ; \
	done

lint:
	$(FLUTTER) analyze

format:
	$(FLUTTER) format --set-exit-if-changed .

testing:
	$(FLUTTER) test
	for feature in $(FEATURES); do \
		cd $${feature} ; \
		echo "Running test on $${feature}" ; \
		$(FLUTTER) test ; \
		cd ../../../ ; \
	done
	for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Running test on $${package}" ; \
		$(FLUTTER) test ; \
		cd ../../ ; \
	done

test-coverage:
	$(FLUTTER) test --coverage
	for feature in $(FEATURES); do \
		cd $${feature} ; \
		echo "Running test on $${feature}" ; \
		$(FLUTTER) test --coverage ; \
		cd ../../../ ; \
	done
	for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Running test on $${package}" ; \
		$(FLUTTER) test --coverage ; \
		cd ../../ ; \
	done

clean:
	$(FLUTTER) clean
	for feature in $(FEATURES); do \
		cd $${feature} ; \
		echo "Running clean on $${feature}" ; \
		$(FLUTTER) clean ; \
		cd ../../../ ; \
	done
	for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Running clean on $${package}" ; \
		$(FLUTTER) clean ; \
		cd ../../ ; \
	done

build-android:
	$(FLUTTER) build apk --release
	