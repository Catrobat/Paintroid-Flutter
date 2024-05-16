# Paintroid

Paintroid, also known as **Pocket Paint**, is associated to [Catroid](https://github.com/Catrobat/Catroid). It is a graphical paint editor application for the Android platform that, among others, allows setting parts of pictures to transparent.

Since Pocket Paint is now available in **Google Play store** you can also download Paintroid (Pocket Paint) from [here](https://play.google.com/store/apps/details?id=org.catrobat.paintroid). Alternatively, you can find it on **F-Droid** [here](https://f-droid.org/packages/org.catrobat.paintroid/).

For more information oriented towards developers please visit our [developers page](http://developer.catrobat.org/).

> **Note** This repository is the Flutter version of [Paintroid](https://github.com/Catrobat/Paintroid)

## Getting Started

1. Install [Flutter](https://docs.flutter.dev/get-started/install):
   - Currently used version specified in _.github/workflows/main.yml_
   - **Recommended**: Use [fvm](https://fvm.app/) for managing Flutter versions
2. Get dependencies: `make get`
3. Run app: `make run`

> In case `make` does not work for you, `melos` can be used for most of the commands. Check them out in _Makefile_ or in _melos.yaml_.

What `make get` does:

- Runs `./setup-sdk.sh`, if _fvm_ is not installed:
  - changes "FLUTTER" (= `fvm flutter`) to `flutter` in _Makefile_
  - changes "DART" (= `fvm dart`) to `dart` in _Makefile_ if _fvm_
  - changes "sdkPath" (= `.fvm/flutter_sdk`) to `auto` in _melos.yaml_
- Runs `./setup-melos.sh`: activates _melos_ if not activated.

## Building generated files

- For **protoc**:
  - Set up the [Protocol Buffer](https://grpc.io/docs/languages/dart/quickstart/) compiler
  - Run `./generate_protos.sh`
- For **build-runner**: run `make build`
- For **localizations**: run `make languages`

## Tests

- Run tests for **all** packages:
  - all: `make test`
  - unit: `make test-unit`
  - widget: `make test-widget`
- Run tests for a **specific** package:
  - all: `melos test`
  - unit: `melos test-unit`
  - widget: `melos test-widget`

**For integration tests:**

1. Make sure you have an iOS/Android device online by running `flutter devices`
2. `cd` into the package where the test is located
3. Run `flutter test <path-to-integartion-test> -d <DEVICE-ID>`
   - Replace `<Device-ID>` with the ID of the device from `flutter devices`
   - Replace `<path-to-integartion-test>` with the actual path to the test (_test/..._)

## Issues

**Please report all bugs on our [Jira Bugtracker](https://catrobat.atlassian.net/jira/)**

## Contributing

If you want to contribute we suggest that you start with [forking](https://help.github.com/articles/fork-a-repo/) our repository and browse the code. Then you can look at our [Issue-Tracker](https://catrobat.atlassian.net/jira/software/c/projects/PAINTROID/issues/PAINTROID-678?filter=allissues&jql=project%20%3D%20%22PAINTROID%22%0Aand%20status%20%3D%20%22Ready%20For%20Development%22%0Aand%20assignee%20%3D%20empty%0Aand%20type%20in%20%28Bug%2C%20Story%2C%20Task%29%0Aand%20labels%20%3D%20Flutter%0AORDER%20BY%20created%20DESC) and start with fixing one ticket. Please make sure to pick a ticket with the status "Ready for development" and comment on the ticket that you are working on it. We strictly use [Test-Driven Development](http://c2.com/cgi/wiki?TestDrivenDevelopment) and [Clean Code](http://www.planetgeek.ch/wp-content/uploads/2013/06/Clean-Code-V2.2.pdf), so first read everything you can about these development methods. Code developed in a different style will not be accepted.
When you are done, comment again on the ticket and create a pull request on github.
After you've created a pull request we will review your code and do a full testrun on your branch.

Let's start to set up the working environment using the instructions in our [Wiki](https://github.com/Catrobat/Catroid/wiki/Setup-working-environment)!

## Resources and links

- [Google Play Store Download](https://play.google.com/store/apps/details?id=org.catrobat.paintroid)
- [F-Droid Download](https://f-droid.org/packages/org.catrobat.paintroid/)
- [Frequently Asked Questions](https://github.com/Catrobat/Catroid/wiki/Frequently-Asked-Questions)
- [Credits](http://developer.catrobat.org/credits)
- [Statistics on OpenHub](https://www.openhub.net/p/catrobat/)
- [Twitter](http://twitter.com/Catroid)
- [Our Google group](https://groups.google.com/forum/?fromgroups#!forum/catrobat)

## License

[License](http://developer.catrobat.org/licenses) of our project (mainly AGPL v3).
