import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oxidized/oxidized.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:paintroid/app.dart';
import 'package:paintroid/core/database/project_dao.dart';
import 'package:paintroid/core/database/project_database.dart';
import 'package:paintroid/core/models/database/project.dart';
import 'package:paintroid/core/providers/object/device_service.dart';
import 'package:paintroid/core/providers/object/file_service.dart';
import 'package:paintroid/core/providers/object/image_service.dart';
import 'package:paintroid/core/providers/state/canvas_state_provider.dart';
import 'package:paintroid/ui/pages/landing_page/components/main_overflow_menu.dart';
import 'package:paintroid/ui/pages/landing_page/components/project_overflow_menu.dart';
import 'package:paintroid/ui/pages/workspace_page/components/top_bar/overflow_menu.dart';
import 'package:paintroid/ui/pages/workspace_page/components/top_bar/top_app_bar.dart';
import 'package:paintroid/ui/shared/dialogs/about_dialog.dart';
import 'package:paintroid/ui/shared/dialogs/generic_dialog.dart';
import 'package:paintroid/ui/shared/dialogs/project_details_dialog.dart';

import 'landing_page_test.mocks.dart';

@GenerateMocks(
    [ProjectDatabase, ProjectDAO, IImageService, IFileService, IDeviceService])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const String testIDStr = String.fromEnvironment('id', defaultValue: '-1');
  final testID = int.tryParse(testIDStr) ?? testIDStr;

  late Widget sut;
  late ProjectDatabase mockDatabase;
  late ProjectDAO mockDao;
  late IImageService mockImageService;
  late IFileService mockFileService;
  late IDeviceService mockDeviceService;
  late List<Project> testProjects;
  final testDate = DateTime.now();
  const testFilePath = 'test/assets/images/test.jpg';
  final testFile = File(testFilePath);
  late ui.Image dummyImage;
  final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm:ss');

  Project createTestProject(String name) => Project(
        name: name,
        path: testFilePath,
        imagePreviewPath: testFilePath,
        lastModified: testDate,
        creationDate: testDate,
      );

  setUp(() async {
    mockDatabase = MockProjectDatabase();
    mockDao = MockProjectDAO();
    mockImageService = MockIImageService();
    mockFileService = MockIFileService();
    mockDeviceService = MockIDeviceService();

    sut = ProviderScope(
      overrides: [
        ProjectDatabase.provider
            .overrideWith((ref) => Future.value(mockDatabase)),
        IImageService.provider.overrideWith((ref) => mockImageService),
        IFileService.provider.overrideWith((ref) => mockFileService),
        IDeviceService.provider.overrideWith((ref) => mockDeviceService),
      ],
      child: App(showOnboardingPage: false),
    );

    testProjects =
        List.generate(5, (index) => createTestProject('project$index'));
    dummyImage = await createTestImage(width: 1080, height: 1920);

    when(mockDatabase.projectDAO).thenReturn(mockDao);
    when(mockImageService.getProjectPreview(testFilePath))
        .thenReturn(Result.ok(testFile.readAsBytesSync()));
    when(mockDeviceService.getSizeInPixels())
        .thenAnswer((_) => Future.value(const Size(1080, 1920)));
  });

  if (testID == -1 || testID == 0) {
    testWidgets('[LANDING_PAGE]: Should show overflow menu options when tapped',
        (WidgetTester tester) async {
      when(mockDao.getProjects()).thenAnswer((_) => Future.value([]));

      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();

      final overflowMenu = find.byType(MainOverflowMenu);
      await tester.tap(overflowMenu);
      await tester.pumpAndSettle();

      expect(find.text('Rate us!'), findsOneWidget);
      expect(find.text('Help'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Feedback'), findsOneWidget);
    });
  }

  if (testID == -1 || testID == 1) {
    testWidgets(
        '[LANDING_PAGE]: Should display About dialog when About is tapped',
        (WidgetTester tester) async {
      when(mockDao.getProjects()).thenAnswer((_) => Future.value([]));

      PackageInfo.setMockInitialValues(
        appName: 'Pocket Paint',
        packageName: 'org.catrobat.paintroid',
        version: '1.0.0',
        buildNumber: '1',
        buildSignature: 'testSignature',
      );

      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(MainOverflowMenu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('About'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(MyAboutDialog, 'About'), findsOneWidget);
      expect(find.text('Version 1.0.0'), findsOneWidget);

      final doneButton = find.widgetWithText(GenericDialogActionButton, 'DONE');
      await tester.tap(doneButton);
      await tester.pumpAndSettle();
      expect(find.widgetWithText(MyAboutDialog, 'About'), findsNothing);
    });
  }

  if (testID == -1 || testID == 2) {
    testWidgets(
        '[LANDING_PAGE]: Should display empty state when no projects exist',
        (WidgetTester tester) async {
      when(mockDao.getProjects()).thenAnswer((_) => Future.value([]));

      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();

      expect(find.byType(ProjectOverflowMenu), findsNothing);
      expect(find.byKey(const Key('myEditIcon')), findsOneWidget);
    });
  }

  if (testID == -1 || testID == 3) {
    testWidgets(
        '[LANDING_PAGE]: Should display project list when projects exist',
        (WidgetTester tester) async {
      when(mockDao.getProjects()).thenAnswer((_) => Future.value(testProjects));

      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();

      expect(find.byType(ProjectOverflowMenu), findsNWidgets(5));

      for (int i = 1; i < testProjects.length; i++) {
        expect(find.text(testProjects[i].name), findsOneWidget);
      }

      final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
      expect(find.text('last modified: ${dateFormat.format(testDate)}'),
          findsNWidgets(4));
    });
  }

  if (testID == -1 || testID == 4) {
    testWidgets('[LANDING_PAGE]: Should show loading indicator initially',
        (WidgetTester tester) async {
      when(mockDao.getProjects()).thenAnswer((_) => Future.delayed(
            const Duration(milliseconds: 100),
            () => <Project>[],
          ));

      await tester.pumpWidget(sut);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  }

  if (testID == -1 || testID == 5) {
    testWidgets('[LANDING_PAGE]: Should show project menu options',
        (WidgetTester tester) async {
      when(mockDao.getProjects()).thenAnswer((_) => Future.value(testProjects));

      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();

      const position = 1;
      final overflowMenu =
          find.byKey(const Key('ProjectOverflowMenu Key$position'));
      await tester.tap(overflowMenu);
      await tester.pumpAndSettle();

      expect(find.text('Delete'), findsOneWidget);
      expect(find.text('Details'), findsOneWidget);
      expect(find.text('Rename'), findsOneWidget);
    });
  }

  if (testID == -1 || testID == 6) {
    testWidgets('[LANDING_PAGE]: Should show project details dialog',
        (WidgetTester tester) async {
      when(mockDao.getProjects()).thenAnswer((_) => Future.value(testProjects));
      when(mockFileService.getFile(testFilePath))
          .thenReturn(Result.ok(testFile));
      when(mockImageService.import(testFile.readAsBytesSync()))
          .thenAnswer((_) => Future.value(Result.ok(dummyImage)));

      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();

      const position = 1;
      final overflowMenu =
          find.byKey(const Key('ProjectOverflowMenu Key$position'));
      await tester.tap(overflowMenu);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Details'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ProjectDetailsDialog, 'project$position'),
          findsOneWidget);
      expect(find.text('Resolution: 1080 X 1920'), findsOneWidget);
      expect(find.text('Last modified: ${formatter.format(testDate)}'),
          findsOneWidget);
      expect(find.text('Creation date: ${formatter.format(testDate)}'),
          findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, 'OK'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(ProjectDetailsDialog, 'project$position'),
          findsNothing);
    });
  }

  if (testID == -1 || testID == 7) {
    testWidgets('[LANDING_PAGE]: Should show delete confirmation dialog',
        (WidgetTester tester) async {
      when(mockDao.getProjects()).thenAnswer((_) => Future.value(testProjects));

      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();

      const position = 1;
      final overflowMenu =
          find.byKey(const Key('ProjectOverflowMenu Key$position'));
      await tester.tap(overflowMenu);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(GenericDialog, 'Delete project$position'),
          findsOneWidget);
      expect(find.text('Do you really want to delete your project?'),
          findsOneWidget);
      expect(find.widgetWithText(GenericDialogActionButton, 'Cancel'),
          findsOneWidget);
      expect(find.widgetWithText(GenericDialogActionButton, 'Delete'),
          findsOneWidget);

      await tester
          .tap(find.widgetWithText(GenericDialogActionButton, 'Cancel'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(GenericDialog, 'Delete project$position'),
          findsNothing);
    });
  }

  if (testID == -1 || testID == 8) {
    testWidgets('[LANDING_PAGE]: Should show rename dialog',
        (WidgetTester tester) async {
      when(mockDao.getProjects()).thenAnswer((_) => Future.value(testProjects));

      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();

      const position = 1;
      final overflowMenu =
          find.byKey(const Key('ProjectOverflowMenu Key$position'));
      await tester.tap(overflowMenu);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Rename'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(GenericDialog, 'Rename project$position'),
          findsOneWidget);
      expect(find.widgetWithText(GenericDialogActionButton, 'CANCEL'),
          findsOneWidget);
      expect(find.widgetWithText(GenericDialogActionButton, 'RENAME'),
          findsOneWidget);
      expect(find.byKey(const Key('textInputField')), findsOneWidget);

      await tester
          .tap(find.widgetWithText(GenericDialogActionButton, 'CANCEL'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(GenericDialog, 'Rename project$position'),
          findsNothing);
    });
  }

  if (testID == -1 || testID == 9) {
    testWidgets(
        '[LANDING_PAGE]: Should navigate to workspace when new image button is tapped',
        (WidgetTester tester) async {
      when(mockDao.getProjects()).thenAnswer((_) => Future.value([]));

      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();

      final newImageButton =
          find.widgetWithIcon(FloatingActionButton, Icons.add);
      await tester.tap(newImageButton);
      await tester.pumpAndSettle();

      expect(find.byType(TopAppBar), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.widgetWithText(TopAppBar, 'Pocket Paint'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('My Projects'), findsOneWidget);
    });
  }

  if (testID == -1 || testID == 10) {
    testWidgets(
        '[LANDING_PAGE]: Should navigate to workspace when edit icon is tapped with no projects',
        (WidgetTester tester) async {
      when(mockDao.getProjects()).thenAnswer((_) => Future.value([]));

      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();

      final editIcon = find.byKey(const Key('myEditIcon'));
      await tester.tap(editIcon);
      await tester.pumpAndSettle();

      expect(find.byType(TopAppBar), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);

      final container = ProviderContainer();
      final canvasState = container.read(canvasStateProvider);
      expect(canvasState.backgroundImage, isNull);
      expect(canvasState.cachedImage, isNull);
      expect(canvasState.size, equals(Size.zero));

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('My Projects'), findsOneWidget);
    });
  }

  if (testID == -1 || testID == 11) {
    testWidgets(
        '[LANDING_PAGE]: Should navigate to OnboardingPage via Help menu and then return',
        (WidgetTester tester) async {
      when(mockDao.getProjects()).thenAnswer((_) => Future.value([]));
      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();

      final mainOverflowMenuFinder = find.byType(MainOverflowMenu);
      expect(mainOverflowMenuFinder, findsOneWidget);
      await tester.tap(mainOverflowMenuFinder);
      await tester.pumpAndSettle();

      final helpOptionFinder = find.text('Help');
      expect(helpOptionFinder, findsOneWidget);
      await tester.tap(helpOptionFinder);
      await tester.pumpAndSettle();

      expect(find.text('Welcome To Pocket Paint'), findsOneWidget,
          reason: 'Should be on OnboardingPage');

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pop();
      await tester.pumpAndSettle();

      expect(find.text('My Projects'), findsOneWidget,
          reason: 'Should have navigated back to LandingPage');
    });
  }

  if (testID == -1 || testID == 12) {
    testWidgets('[LANDING_PAGE]: Should save new project successfully',
        (WidgetTester tester) async {
      const projectName = 'test-project';
      when(mockDao.getProjects()).thenAnswer((_) => Future.value([]));
      when(mockFileService.checkIfFileExistsInApplicationDirectory(
              '$projectName.catrobat-image'))
          .thenAnswer((_) => Future.value(false));

      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();

      final newImageButton =
          find.widgetWithIcon(FloatingActionButton, Icons.add);
      await tester.tap(newImageButton);
      await tester.pumpAndSettle();

      final overflowMenuButton = find.widgetWithIcon(
        PopupMenuButton<OverflowMenuOption>,
        Icons.more_vert,
      );
      await tester.tap(overflowMenuButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save project'));
      await tester.pumpAndSettle();

      final projectNameField =
          find.widgetWithText(TextFormField, 'Project name');
      await tester.enterText(projectNameField, projectName);
      await tester.tap(find.widgetWithText(TextButton, 'Save'));
      await tester.pumpAndSettle();

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('My Projects'), findsOneWidget);
    });
  }

  if (testID == -1 || testID == 13) {
    testWidgets(
        '[LANDING_PAGE]: Should show overwrite confirmation for existing project name',
        (WidgetTester tester) async {
      const projectName = 'existing-project';
      final existingProject = createTestProject('$projectName.catrobat-image');

      when(mockDao.getProjects())
          .thenAnswer((_) => Future.value([existingProject]));
      when(mockFileService.checkIfFileExistsInApplicationDirectory(
              '$projectName.catrobat-image'))
          .thenAnswer((_) => Future.value(true));

      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();

      final newImageButton =
          find.widgetWithIcon(FloatingActionButton, Icons.add);
      await tester.tap(newImageButton);
      await tester.pumpAndSettle();

      final overflowMenuButton = find.widgetWithIcon(
        PopupMenuButton<OverflowMenuOption>,
        Icons.more_vert,
      );
      await tester.tap(overflowMenuButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save project'));
      await tester.pumpAndSettle();

      final projectNameField =
          find.widgetWithText(TextFormField, 'Project name');
      await tester.enterText(projectNameField, projectName);
      await tester.tap(find.widgetWithText(TextButton, 'Save'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(GenericDialog, 'Overwrite'), findsOneWidget);
    });
  }

  if (testID == -1 || testID == 14) {
    testWidgets(
        '[LANDING_PAGE]: Should handle database loading errors gracefully',
        (WidgetTester tester) async {
      when(mockDao.getProjects()).thenThrow(Exception('Database error'));

      await tester.pumpWidget(sut);

      expect(find.byType(Scaffold), findsOneWidget);
    });
  }
}
