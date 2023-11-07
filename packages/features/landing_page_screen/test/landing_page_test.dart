import 'dart:io';
import 'dart:ui' as ui;

import 'package:component_library/component_library.dart';
import 'package:database/database.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:io_library/io_library.dart';
import 'package:landing_page_screen/landing_page_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oxidized/oxidized.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:paintroid/pocket_paint_app.dart';

import 'landing_page_test.mocks.dart';

@GenerateMocks([ProjectDatabase, ProjectDAO, IImageService, IFileService])
void main() {
  late Widget sut;
  late ProjectDatabase database;
  late ProjectDAO dao;
  late IImageService imageService;
  late IFileService fileService;
  late List<Project> projects;
  final date = DateTime.now();
  const filePath = 'test/fixture/image/test.jpg';
  final testFile = File(filePath);
  late ui.Image dummyImage;
  final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm:ss');

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
    sut = ProviderScope(
      overrides: [
        ProjectDatabase.provider.overrideWith((ref) => Future.value(database)),
        IImageService.provider.overrideWith((ref) => imageService),
        IFileService.provider.overrideWith((ref) => fileService),
      ],
      child: const PocketPaintApp(
        showOnboardingPage: false,
      ),
    );
    projects = List.generate(5, (index) => createProject('project$index'));
    dummyImage = await createTestImage(width: 1080, height: 1920);
  });

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
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());
      final titleFinder = find.widgetWithText(AppBar, 'Pocket Paint');
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
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());
      final mainOverflowMenu = find.byType(MainOverflowMenu);
      expect(mainOverflowMenu, findsOneWidget);
      await tester.tap(mainOverflowMenu);
      await tester.pumpAndSettle();

      expect(find.text('Rate us!'), findsOneWidget);
      expect(find.text('Help'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Feedback'), findsOneWidget);
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
    'Should have "My Projects" section',
    (tester) async {
      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects()).thenAnswer((_) => Future.value([]));
      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());
      expect(find.text('My Projects'), findsOneWidget);
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
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());
      verify(imageService.getProjectPreview(filePath)).called(5);
      expect(find.byType(ProjectOverflowMenu), findsNWidgets(5));
      final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
      expect(find.text('last modified: ${dateFormat.format(date)}'),
          findsNWidgets(4));
      for (int i = 1; i < 5; i++) {
        expect(find.text(projects[i].name), findsOneWidget);
      }
    },
  );

  testWidgets(
    'Should have "Delete" and "Details" options in ProjectOverflowMenu',
    (tester) async {
      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects()).thenAnswer((_) => Future.value(projects));
      when(imageService.getProjectPreview(filePath))
          .thenReturn(Result.ok(testFile.readAsBytesSync()));
      await tester.pumpWidget(sut);
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

      expect(find.text('Delete'), findsOneWidget);
      expect(find.text('Details'), findsOneWidget);
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

      final detailsOption = find.text('Details');
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
      expect(find.text('Resolution: 1080 X 1920'), findsOneWidget);
      expect(find.text('Last modified: ${formatter.format(date)}'),
          findsOneWidget);
      expect(find.text('Creation date: ${formatter.format(date)}'),
          findsOneWidget);
      expect(find.text('Size: ${filesize(testFile.lengthSync())}'),
          findsOneWidget);

      final okButton = find.widgetWithText(TextButton, 'OK');
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

      final deleteOption = find.text('Delete');
      expect(deleteOption, findsOneWidget);

      await tester.tap(deleteOption);
      await tester.pumpAndSettle();

      final deleteProjectDialog =
          find.widgetWithText(GenericDialog, 'Delete project$position');
      expect(deleteProjectDialog, findsOneWidget);
      expect(find.text('Do you really want to delete your project?'),
          findsOneWidget);
      final cancelButton =
          find.widgetWithText(GenericDialogActionButton, 'Cancel');
      final deleteButton =
          find.widgetWithText(GenericDialogActionButton, 'Delete');
      expect(cancelButton, findsOneWidget);
      expect(deleteButton, findsOneWidget);
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();
      expect(deleteProjectDialog, findsNothing);
    },
  );

  testWidgets(
    'Should show AboutDialog',
    (tester) async {
      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects()).thenAnswer((_) => Future.value([]));
      await tester.pumpWidget(sut);
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
      final about = find.text('About');
      await tester.tap(about);
      await tester.pumpAndSettle();

      expect(find.widgetWithText(MyAboutDialog, 'About'), findsOneWidget);
      expect(find.text('Version 1.0.0'), findsOneWidget);

      final doneButton = find.widgetWithText(GenericDialogActionButton, 'DONE');
      expect(doneButton, findsOneWidget);
      await tester.tap(doneButton);
      await tester.pumpAndSettle();
      expect(find.widgetWithText(MyAboutDialog, 'About'), findsNothing);
    },
  );

  testWidgets(
    'Should open PocketPaint widget and return back to Landing page',
    (tester) async {
      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects()).thenAnswer((_) => Future.value([]));
      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();
      verify(database.projectDAO);
      verify(dao.getProjects());

      final addButton = find.widgetWithIcon(FloatingActionButton, Icons.add);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      expect(find.byType(TopAppBar), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);

      final titleFinder = find.widgetWithText(TopAppBar, 'Pocket Paint');
      expect(titleFinder, findsOneWidget);

      final overflowMenuButtonFinder = find.widgetWithIcon(
        PopupMenuButton<OverflowMenuOption>,
        Icons.more_vert,
      );
      expect(overflowMenuButtonFinder, findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('My Projects'), findsOneWidget);
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

      final saveProjectButton = find.text('Save project');
      expect(saveProjectButton, findsOneWidget);

      await tester.tap(saveProjectButton);
      await tester.pumpAndSettle();

      final textFormField = find.widgetWithText(TextFormField, 'Project name');
      expect(textFormField, findsOneWidget);

      await tester.enterText(textFormField, 'project');

      final saveButton = find.widgetWithText(TextButton, 'Save');
      expect(saveButton, findsOneWidget);

      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      final confirmationDialogFinder =
          find.widgetWithText(GenericDialog, 'Overwrite');

      expect(confirmationDialogFinder, findsOneWidget);
    },
  );
}
