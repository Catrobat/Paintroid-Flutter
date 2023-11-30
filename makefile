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
	@for feature in $(FEATURES); do \
		echo $${feature} ; \
	done
	@for package in $(PACKAGES); do \
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
	@for feature in $(FEATURES); do \
		cd $${feature} ; \
		echo "Updating dependencies on $${feature}" ; \
		$(FLUTTER) pub get ; \
		cd ../../../ ; \
	done
	@for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Updating dependencies on $${package}" ; \
		$(FLUTTER) pub get ; \
		cd ../../ ; \
	done

build-runner:
	@for feature in $(FEATURES); do \
		cd $${feature} ; \
		echo "Running build-runner on $${feature}" ; \
		$(FLUTTER) pub run build_runner build --delete-conflicting-outputs ; \
		cd ../../../ ; \
	done
	@for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Running build-runner on $${package}" ; \
		$(FLUTTER) pub run build_runner build --delete-conflicting-outputs ; \
		cd ../../ ; \
	done

languages:
	@cd packages/l10n ; \
	$(FLUTTER) gen-l10n

lint:
	$(FLUTTER) analyze

format:
	$(FLUTTER) format --set-exit-if-changed .

clean:
	$(FLUTTER) clean
	@for feature in $(FEATURES); do \
		cd $${feature} ; \
		echo "Running clean on $${feature}" ; \
		$(FLUTTER) clean ; \
		cd ../../../ ; \
	done
	@for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Running clean on $${package}" ; \
		$(FLUTTER) clean ; \
		cd ../../ ; \
	done

testing:
	@echo "Running test on Paintroid"
	@{ \
		TEST_OUTPUT=$$(${FLUTTER} test); \
		if echo "$$TEST_OUTPUT" | grep -q "All tests passed!"; then \
			echo "✅ All tests passed in Paintroid"; \
		elif echo "$$TEST_OUTPUT" | grep -q "failed"; then \
			echo "❌ Some tests failed in Paintroid"; \
		else \
			echo "🫣 No tests for Paintroid"; \
		fi; \
	}
	@for feature in $(FEATURES); do \
		cd $${feature} ; \
		echo "Running test on $${feature}" ; \
		TEST_OUTPUT=$$(${FLUTTER} test) ; \
		if echo "$$TEST_OUTPUT" | grep -q "All tests passed!"; then \
			echo "✅ All tests passed in $${feature}" ; \
		elif echo "$$TEST_OUTPUT" | grep -q "failed"; then \
			echo "❌ Some tests failed in $${feature}" ; \
		else \
			echo "🫣 No tests for $${feature}" ; \
		fi ; \
		cd ../../../ ; \
		sleep 1 ; \
	done
	@for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Running test on $${package}" ; \
		TEST_OUTPUT=$$(${FLUTTER} test) ; \
		if echo "$$TEST_OUTPUT" | grep -q "All tests passed!"; then \
			echo "✅ All tests passed in $${package}" ; \
		elif echo "$$TEST_OUTPUT" | grep -q "failed"; then \
			echo "❌ Some tests failed in $${package}" ; \
		else \
			echo "🫣 No tests for $${package}" ; \
		fi ; \
		cd ../../ ; \
		sleep 1 ; \
	done

testing-output:
	$(FLUTTER) test
	@for feature in $(FEATURES); do \
		cd $${feature} ; \
		echo "Running test on $${feature}" ; \
		$(FLUTTER) test ; \
		cd ../../../ ; \
	done
	@for package in $(PACKAGES); do \
		cd $${package} ; \
		echo "Running test on $${package}" ; \
		$(FLUTTER) test ; \
		cd ../../ ; \
	done

