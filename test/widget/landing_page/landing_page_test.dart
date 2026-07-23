import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:filesize/filesize.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oxidized/oxidized.dart';
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
import 'package:paintroid/ui/pages/landing_page/components/project_list_tile.dart';
import 'package:paintroid/ui/pages/landing_page/components/project_overflow_menu.dart';
import 'package:paintroid/ui/pages/workspace_page/components/top_bar/overflow_menu.dart';
import 'package:paintroid/ui/pages/workspace_page/components/top_bar/top_app_bar.dart';
import 'package:paintroid/ui/shared/dialogs/about_dialog.dart';
import 'package:paintroid/ui/shared/dialogs/generic_dialog.dart';
import 'package:paintroid/ui/shared/dialogs/project_details_dialog.dart';
import 'landing_page_test.mocks.dart';
import 'package:paintroid/core/localization/app_localizations.dart';

@GenerateMocks(
    [ProjectDatabase, ProjectDAO, IImageService, IFileService, IDeviceService])
void main() {
  late Widget sut;
  late ProjectDatabase database;
  late ProjectDAO dao;
  late IImageService imageService;
  late IFileService fileService;
  late IDeviceService deviceService;
  late List<Project> projects;
  final date = DateTime.now();
  const filePath = 'test/assets/images/test.jpg';
  final testFile = File(filePath);
  late ui.Image dummyImage;
  final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm:ss');
  late AppLocalizations localizations;

  Project createProject(String name) => Project(
        name: name,
        path: filePath,
        imagePreviewPath: filePath,
        lastModified: date,
        creationDate: date,
      );

  setUp(() async {
    database = MockProjectDatabase();
    dao = MockProjectDAO();
    imageService = MockIImageService();
    fileService = MockIFileService();
    deviceService = MockIDeviceService();
    sut = ProviderScope(
      overrides: [
        ProjectDatabase.provider.overrideWith((ref) => Future.value(database)),
        IImageService.provider.overrideWith((ref) => imageService),
        IFileService.provider.overrideWith((ref) => fileService),
        IDeviceService.provider.overrideWith((ref) => deviceService),
      ],
      child: App(
        showOnboardingPage: false,
      ),
    );
    projects = List.generate(5, (index) => createProject('project$index'));
    dummyImage = await createTestImage(width: 1080, height: 1920);
  });

  Future<void> initializeAppAndLocalizations(WidgetTester tester) async {
    final appBarFinder = find.byType(AppBar);
    if (tester.any(appBarFinder)) {
      localizations = AppLocalizations.of(tester.element(appBarFinder.first));
      return;
    }

    final mainAppFinder = find.byType(MaterialApp);
    if (tester.any(mainAppFinder)) {
      localizations = AppLocalizations.of(tester.element(mainAppFinder.first));
      return;
    }

    expect(false, isTrue,
        reason:
            'Localizations not found. Ensure MaterialApp or AppBar is present.');
  }

  testWidgets('Should have a top app bar', (tester) async {
    when(database.projectDAO).thenReturn(dao);
    when(dao.getProjects()).thenAnswer((_) => Future.value([]));
    await tester.pumpWidget(sut);
    await tester.pumpAndSettle();
    verify(database.projectDAO);
    verify(dao.getProjects());
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets(
    'Should have the title "Pocket Paint" in app bar',
    (tester) async {
      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects()).thenAnswer((_) => Future.value([]));

      await tester.pumpWidget(sut);
      await initializeAppAndLocalizations(tester);
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());
      final titleFinder = find.widgetWithText(AppBar, localizations.pocketpaintAppName);
      expect(titleFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Should have the MainOverflowMenu in app bar',
    (tester) async {
      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects()).thenAnswer((_) => Future.value([]));
      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());
      expect(find.byType(MainOverflowMenu), findsOneWidget);
    },
  );

  testWidgets(
    'Should have "Rate us!", "Help", "About", "Feedback" options in MainOverflowMenu',
    (tester) async {
      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects()).thenAnswer((_) => Future.value([]));

      await tester.pumpWidget(sut);
      await initializeAppAndLocalizations(tester);
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());
      final mainOverflowMenu = find.byType(MainOverflowMenu);
      expect(mainOverflowMenu, findsOneWidget);
      await tester.tap(mainOverflowMenu);
      await tester.pumpAndSettle();

      expect(find.text(localizations.menuRateUs), findsOneWidget);
      expect(find.text(localizations.helpTitle), findsOneWidget);
      expect(find.text(localizations.pocketpaintAboutTitle), findsOneWidget);
      expect(find.text(localizations.menuFeedback), findsOneWidget);
    },
  );

  testWidgets(
    'Should tap Rate us! option and handle it without crashing',
    (tester) async {
      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects()).thenAnswer((_) => Future.value([]));

      await tester.pumpWidget(sut);
      await initializeAppAndLocalizations(tester);
      await tester.pumpAndSettle();

      final mainOverflowMenu = find.byType(MainOverflowMenu);
      expect(mainOverflowMenu, findsOneWidget);

      await tester.tap(mainOverflowMenu);
      await tester.pumpAndSettle();

      await tester.tap(find.text(localizations.menuRateUs));
      await tester.pumpAndSettle();

      expect(mainOverflowMenu, findsOneWidget);
    },
  );

  testWidgets(
    'Should have the two FABs',
    (tester) async {
      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects()).thenAnswer((_) => Future.value([]));
      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());
      expect(
        find.widgetWithIcon(FloatingActionButton, Icons.add),
        findsOneWidget,
      );
      expect(
        find.widgetWithIcon(FloatingActionButton, Icons.file_download),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should open PocketPaint widget trough edit (new project) icon and return back to Landing page',
    (tester) async {
      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects()).thenAnswer((_) => Future.value([]));

      await tester.pumpWidget(sut);
      await initializeAppAndLocalizations(tester);
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());

      final editButton = find.byKey(const Key('myEditIcon'));
      await tester.tap(editButton);
      await tester.pumpAndSettle();

      expect(find.byType(TopAppBar), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);

      final titleFinder = find.widgetWithText(TopAppBar, localizations.pocketpaintAppName);
      expect(titleFinder, findsOneWidget);

      final overflowMenuButtonFinder = find.widgetWithIcon(
        PopupMenuButton<OverflowMenuOption>,
        Icons.more_vert,
      );
      expect(overflowMenuButtonFinder, findsOneWidget);

      // Check the canvas is empty
      final container = ProviderContainer();
      final canvasState = container.read(canvasStateProvider);
      expect(canvasState.backgroundImage, isNull);
      expect(canvasState.cachedImage, isNull);
      expect(canvasState.size, equals(Size.zero));

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text(localizations.myProjects), findsOneWidget);
    },
  );

  testWidgets(
    'Should open PocketPaint widget trough edit (new project) icon save it and return back to Landing page. Then open the project trough edit icon.',
    (tester) async {
      String projectName = 'project.catrobat-image';

      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects()).thenAnswer((_) => Future.value([]));
      when(fileService.checkIfFileExistsInApplicationDirectory(projectName))
          .thenAnswer((_) => Future.value(false));
      when(imageService.getProjectPreview(filePath))
          .thenReturn(Result.ok(testFile.readAsBytesSync()));

      await tester.pumpWidget(sut);
      await initializeAppAndLocalizations(tester);
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());

      final plusButton = find.byKey(const Key('myEditIcon'));
      expect(plusButton, findsOneWidget);
      await tester.tap(plusButton);
      await tester.pumpAndSettle();

      expect(find.byType(TopAppBar), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);

      final titleFinder = find.widgetWithText(TopAppBar, localizations.pocketpaintAppName);
      expect(titleFinder, findsOneWidget);

      final overflowMenuButtonFinder = find.widgetWithIcon(
        PopupMenuButton<OverflowMenuOption>,
        Icons.more_vert,
      );
      expect(overflowMenuButtonFinder, findsOneWidget);

      // Check the canvas is empty
      final container = ProviderContainer();
      final canvasState = container.read(canvasStateProvider);
      expect(canvasState.backgroundImage, isNull);
      expect(canvasState.cachedImage, isNull);
      expect(canvasState.size, equals(Size.zero));

      await tester.tap(overflowMenuButtonFinder);
      await tester.pumpAndSettle();

      final saveProjectButton = find.text(localizations.menuSaveProject);
      expect(saveProjectButton, findsOneWidget);

      await tester.tap(saveProjectButton);
      await tester.pumpAndSettle();

      final textFormField = find.widgetWithText(TextFormField, localizations.dialogSaveProjectName);
      expect(textFormField, findsOneWidget);

      await tester.enterText(textFormField, 'project');

      final saveButton = find.widgetWithText(TextButton, localizations.saveButtonText.toUpperCase());
      expect(saveButton, findsOneWidget);

      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.text('My Projects'), findsOneWidget);

      final editButton = find.byKey(const Key('myEditIcon'));
      await tester.tap(editButton);
      await tester.pumpAndSettle();

      expect(find.byType(TopAppBar), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);

      final titleFinder2 = find.widgetWithText(TopAppBar, localizations.pocketpaintAppName);
      expect(titleFinder2, findsOneWidget);

      final overflowMenuButtonFinder2 = find.widgetWithIcon(
        PopupMenuButton<OverflowMenuOption>,
        Icons.more_vert,
      );
      expect(overflowMenuButtonFinder2, findsOneWidget);
    },
  );

  testWidgets(
    'Should have "My Projects" section',
    (tester) async {
      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects()).thenAnswer((_) => Future.value([]));

      await tester.pumpWidget(sut);
      await initializeAppAndLocalizations(tester);
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());
      expect(find.text(localizations.myProjects), findsOneWidget);
    },
  );

  testWidgets(
    'Should not show ProjectOverflowMenu',
    (tester) async {
      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects()).thenAnswer((_) => Future.value([]));
      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());
      expect(find.byType(ProjectOverflowMenu), findsNothing);
    },
  );

  testWidgets(
    'Should show projects in the list',
    (tester) async {
      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects()).thenAnswer((_) => Future.value(projects));
      when(imageService.getProjectPreview(filePath))
          .thenReturn(Result.ok(testFile.readAsBytesSync()));

      await tester.pumpWidget(sut);
      await initializeAppAndLocalizations(tester);
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());
      verify(imageService.getProjectPreview(filePath)).called(5);
      expect(find.byType(ProjectOverflowMenu), findsNWidgets(5));
      final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
      expect(find.text('${localizations.detailsLastModified}: ${dateFormat.format(date)}'),
          findsNWidgets(4));
      for (int i = 1; i < 5; i++) {
        expect(find.text(projects[i].name), findsOneWidget);
      }
    },
  );

  testWidgets(
    'Should have "Delete", "Details" and "Rename" options in ProjectOverflowMenu',
    (tester) async {
      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects()).thenAnswer((_) => Future.value(projects));
      when(imageService.getProjectPreview(filePath))
          .thenReturn(Result.ok(testFile.readAsBytesSync()));

      await tester.pumpWidget(sut);
      await initializeAppAndLocalizations(tester);
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());
      verify(imageService.getProjectPreview(filePath)).called(5);

      expect(find.byType(ProjectOverflowMenu), findsNWidgets(5));

      const position = 1;
      final overflowMenu =
          find.byKey(const Key('ProjectOverflowMenu Key$position'));
      expect(overflowMenu, findsOneWidget);
      await tester.tap(overflowMenu);
      await tester.pumpAndSettle();

      expect(find.text(localizations.projectDelete), findsOneWidget);
      expect(find.text(localizations.projectDetails), findsOneWidget);
      expect(find.text(localizations.projectRename), findsOneWidget);
    },
  );

  testWidgets(
    'Should show ProjectDetailsDialog',
    (tester) async {
      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects()).thenAnswer((_) => Future.value(projects));
      when(imageService.getProjectPreview(filePath))
          .thenReturn(Result.ok(testFile.readAsBytesSync()));

      await tester.pumpWidget(sut);
      await initializeAppAndLocalizations(tester);
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());
      verify(imageService.getProjectPreview(filePath)).called(5);

      const position = 1;
      final overflowMenu =
          find.byKey(const Key('ProjectOverflowMenu Key$position'));
      expect(overflowMenu, findsOneWidget);
      await tester.tap(overflowMenu);
      await tester.pumpAndSettle();

      final detailsOption = find.text(localizations.projectDetails);
      expect(detailsOption, findsOneWidget);

      when(imageService.getProjectPreview(filePath))
          .thenReturn(Result.ok(testFile.readAsBytesSync()));
      when(fileService.getFile(filePath)).thenReturn(Result.ok(testFile));
      when(imageService.import(testFile.readAsBytesSync()))
          .thenAnswer((_) => Future.value(Result.ok(dummyImage)));
      await tester.tap(detailsOption);
      await tester.pumpAndSettle();
      verify(imageService.getProjectPreview(filePath));
      verify(fileService.getFile(filePath));
      verify(imageService.import(testFile.readAsBytesSync()));

      expect(find.widgetWithText(ProjectDetailsDialog, 'project$position'),
          findsOneWidget);
      expect(find.text('${localizations.detailsResolution}: 1080 X 1920'), findsOneWidget);
      expect(find.text('${localizations.detailsLastModified}: ${formatter.format(date)}'),
          findsOneWidget);
      expect(find.text('${localizations.detailsCreationDate}: ${formatter.format(date)}'),
          findsOneWidget);
      expect(find.text('${localizations.detailsSize}: ${filesize(testFile.lengthSync())}'),
          findsOneWidget);

      final okButton = find.widgetWithText(TextButton, localizations.done.toUpperCase());
      expect(okButton, findsOneWidget);
      await tester.tap(okButton);
      await tester.pumpAndSettle();
      expect(find.widgetWithText(ProjectDetailsDialog, 'project$position'),
          findsNothing);
    },
  );

  testWidgets(
    'Should show DeleteProjectDialog',
    (tester) async {
      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects()).thenAnswer((_) => Future.value(projects));
      when(imageService.getProjectPreview(filePath))
          .thenReturn(Result.ok(testFile.readAsBytesSync()));

      await tester.pumpWidget(sut);
      await initializeAppAndLocalizations(tester);
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());
      verify(imageService.getProjectPreview(filePath)).called(5);

      const position = 1;
      final overflowMenu =
          find.byKey(const Key('ProjectOverflowMenu Key$position'));
      expect(overflowMenu, findsOneWidget);
      await tester.tap(overflowMenu);
      await tester.pumpAndSettle();

      final deleteOption = find.text(localizations.projectDelete);
      expect(deleteOption, findsOneWidget);

      await tester.tap(deleteOption);
      await tester.pumpAndSettle();

      final deleteProjectDialog =
          find.widgetWithText(GenericDialog, localizations.projectDeleteTitle('project$position'));
      expect(deleteProjectDialog, findsOneWidget);
      expect(find.text(localizations.projectDeleteDialog),
          findsOneWidget);
      final cancelButton =
          find.widgetWithText(GenericDialogActionButton, localizations.cancelButtonText.toUpperCase());
      final deleteButton =
          find.widgetWithText(GenericDialogActionButton, localizations.deleteButtonText.toUpperCase());
      expect(cancelButton, findsOneWidget);
      expect(deleteButton, findsOneWidget);
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();
      expect(deleteProjectDialog, findsNothing);
    },
  );

  testWidgets(
    'Should show RenameProjectDialog',
    (tester) async {
      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects()).thenAnswer((_) => Future.value(projects));
      when(imageService.getProjectPreview(filePath))
          .thenReturn(Result.ok(testFile.readAsBytesSync()));

      await tester.pumpWidget(sut);
      await initializeAppAndLocalizations(tester);
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());
      verify(imageService.getProjectPreview(filePath)).called(5);

      const position = 1;
      final overflowMenu =
          find.byKey(const Key('ProjectOverflowMenu Key$position'));
      expect(overflowMenu, findsOneWidget);
      await tester.tap(overflowMenu);
      await tester.pumpAndSettle();

      final renameOption = find.text(localizations.projectRename);
      expect(renameOption, findsOneWidget);

      await tester.tap(renameOption);
      await tester.pumpAndSettle();

      final renameProjectDialog =
          find.widgetWithText(GenericDialog, localizations.projectRenameTitle('project$position'));
      expect(renameProjectDialog, findsOneWidget);
      final cancelButton =
          find.widgetWithText(GenericDialogActionButton, localizations.cancelButtonText.toUpperCase());
      final renameButton =
          find.widgetWithText(GenericDialogActionButton, localizations.projectRename.toUpperCase());

      expect(cancelButton, findsOneWidget);
      expect(renameButton, findsOneWidget);

      expect(find.byKey(const Key('textInputField')), findsOneWidget);

      await tester.tap(cancelButton);
      await tester.pumpAndSettle();
      expect(renameProjectDialog, findsNothing);
    },
  );

  testWidgets(
    'Should show AboutDialog',
    (tester) async {
      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects()).thenAnswer((_) => Future.value([]));

      await tester.pumpWidget(sut);
      await initializeAppAndLocalizations(tester);
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());
      final mainOverflowMenu = find.byType(MainOverflowMenu);
      expect(mainOverflowMenu, findsOneWidget);
      await tester.tap(mainOverflowMenu);
      await tester.pumpAndSettle();
      PackageInfo.setMockInitialValues(
        appName: 'Pocket Paint',
        packageName: 'org.catrobat.paintroid',
        version: '1.0.0',
        buildNumber: '1',
        buildSignature: 'testSignature',
      );
      final about = find.text(localizations.pocketpaintAboutTitle);
      await tester.tap(about);
      await tester.pumpAndSettle();

      expect(find.widgetWithText(MyAboutDialog, localizations.pocketpaintAboutTitle), findsOneWidget);
      expect(find.text('Version 1.0.0'), findsOneWidget);

      final doneButton = find.widgetWithText(GenericDialogActionButton, localizations.done.toUpperCase());
      expect(doneButton, findsOneWidget);
      await tester.tap(doneButton);
      await tester.pumpAndSettle();
      expect(find.widgetWithText(MyAboutDialog, localizations.pocketpaintAboutTitle), findsNothing);
    },
  );

  testWidgets(
    'Should open PocketPaint widget and return back to Landing page',
    (tester) async {
      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects()).thenAnswer((_) => Future.value([]));

      await tester.pumpWidget(sut);
      await initializeAppAndLocalizations(tester);
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());

      final addButton = find.widgetWithIcon(FloatingActionButton, Icons.add);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      expect(find.byType(TopAppBar), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);

      final titleFinder = find.widgetWithText(TopAppBar, localizations.pocketpaintAppName);
      expect(titleFinder, findsOneWidget);

      final overflowMenuButtonFinder = find.widgetWithIcon(
        PopupMenuButton<OverflowMenuOption>,
        Icons.more_vert,
      );
      expect(overflowMenuButtonFinder, findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text(localizations.myProjects), findsOneWidget);
    },
  );

  testWidgets(
    'Should show a confirmation dialog when attempting to save a project with a'
    ' name that already exists in the database',
    (tester) async {
      String projectName = 'project.catrobat-image';

      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects())
          .thenAnswer((_) => Future.value([createProject(projectName)]));
      when(fileService.checkIfFileExistsInApplicationDirectory(projectName))
          .thenAnswer((_) => Future.value(true));
      when(imageService.getProjectPreview(filePath))
          .thenReturn(Result.ok(testFile.readAsBytesSync()));

      await tester.pumpWidget(sut);
      await initializeAppAndLocalizations(tester);
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());

      final addButton = find.widgetWithIcon(FloatingActionButton, Icons.add);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      final overflowMenuButtonFinder = find.widgetWithIcon(
        PopupMenuButton<OverflowMenuOption>,
        Icons.more_vert,
      );
      expect(overflowMenuButtonFinder, findsOneWidget);

      await tester.tap(overflowMenuButtonFinder);
      await tester.pumpAndSettle();

      final saveProjectButton = find.text(localizations.menuSaveProject);
      expect(saveProjectButton, findsOneWidget);

      await tester.tap(saveProjectButton);
      await tester.pumpAndSettle();

      final textFormField = find.widgetWithText(TextFormField, localizations.dialogSaveProjectName);
      expect(textFormField, findsOneWidget);

      await tester.enterText(textFormField, 'project');

      final saveButton = find.widgetWithText(TextButton, localizations.saveButtonText.toUpperCase());
      expect(saveButton, findsOneWidget);

      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      final confirmationDialogFinder =
          find.widgetWithText(GenericDialog, localizations.overwriteButtonText.toUpperCase());

      expect(confirmationDialogFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Should show a CircularProgressIndicator when loading the project by clicking the edit button',
    (tester) async {
      String projectName = 'project.catrobat-image';
      Project project = createProject(projectName);
      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects()).thenAnswer((_) => Future.value([project]));
      when(imageService.getProjectPreview(filePath))
          .thenReturn(Result.ok(testFile.readAsBytesSync()));
      when(deviceService.getSizeInPixels())
          .thenAnswer((_) => Future.value(const Size(1080, 1920)));
      when(dao.insertProject(project)).thenAnswer((_) => Future.value(1));
      when(fileService.getFile(filePath)).thenReturn(Result.ok(testFile));

      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());

      final editButton = find.byKey(const Key('myEditIcon'));
      await tester.tap(editButton);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'Should show a CircularProgressIndicator when loading the project by clicking the project tile in list view',
    (tester) async {
      String projectName = 'project.catrobat-image';
      Project project1 = createProject(projectName);
      Project project2 = createProject(projectName);
      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects())
          .thenAnswer((_) => Future.value([project1, project2]));
      when(imageService.getProjectPreview(filePath))
          .thenReturn(Result.ok(testFile.readAsBytesSync()));
      when(deviceService.getSizeInPixels())
          .thenAnswer((_) => Future.value(const Size(1080, 1920)));
      when(dao.insertProject(project2)).thenAnswer((_) => Future.value(1));
      when(fileService.getFile(filePath)).thenReturn(Result.ok(testFile));

      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());

      final projectTile = find.byType(ProjectListTile);
      await tester.tap(projectTile);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );
}
