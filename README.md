# Paintroid

Paintroid, also known as **Pocket Paint**, is associated to [Catroid](https://github.com/Catrobat/Catroid). It is a graphical paint editor application for the Android platform that, among others, allows setting parts of pictures to transparent.

Since Pocket Paint is now available in **Google Play store** you can also download Paintroid (Pocket Paint) from [here](https://play.google.com/store/apps/details?id=org.catrobat.paintroid). Alternatively, you can find it on **F-Droid** [here](https://f-droid.org/packages/org.catrobat.paintroid/).

For more information oriented towards developers please visit our [developers page](http://developer.catrobat.org/).

> **Note** This repository is the Flutter version of [Paintroid](https://github.com/Catrobat/Paintroid)

## Getting Started

1. Install [Flutter](https://docs.flutter.dev/get-started/install)
   - check the currently used version in file ".github/workflows/main.yml"
   - alternatively use fvm for managing Flutter versions
2. Set up the [Protocol Buffer](https://grpc.io/docs/languages/dart/quickstart/) compiler
   - `protoc` for Dart
3. Change `fvm flutter` to `flutter` in `makefile` and `./generate_protos.sh` if you are not using fvm
4. Get dependencies - `make get`
5. Build supporting files - `make build-runner`
6. Build protobuf files - `./generate_protos.sh`
7. Run app - `make run`

## Tests

1. For unit tests, run `flutter test` at the project root
2. For integration tests -
   - Make sure you have an iOS/Android device online by running `flutter devices`
   - Run `flutter test integration_test -d <DEVICE-ID>`
     > **Note** Replace `<Device-ID>` with the ID of the device from previous command

## Issues

**Please report all bugs on our [Jira Bugtracker](https://jira.catrob.at/secure/CreateIssue.jspa?pid=10401&issuetype=1)**

## Contributing

If you want to contribute we suggest that you start with [forking](https://help.github.com/articles/fork-a-repo/) our repository and browse the code. Then you can look at our [Issue-Tracker](https://jira.catrob.at/secure/RapidBoard.jspa?rapidView=60) and start with fixing one ticket. We strictly use [Test-Driven Development](http://c2.com/cgi/wiki?TestDrivenDevelopment) and [Clean Code](http://www.planetgeek.ch/wp-content/uploads/2013/06/Clean-Code-V2.2.pdf), so first read everything you can about these development methods. Code developed in a different style will not be accepted. After you've created a pull request we will review your code and do a full testrun on your branch.

If you want to implement a new feature, please ask about the details in JIRA or our IRC channel (#catrobat or #catrobatdev) first.

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
