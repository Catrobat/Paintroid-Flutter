import 'dart:io';
import 'dart:ui' as ui;

import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oxidized/oxidized.dart';
import 'package:paintroid/data/model/project.dart';
import 'package:paintroid/data/project_dao.dart';
import 'package:paintroid/data/project_database.dart';
import 'package:paintroid/io/io.dart';
import 'package:paintroid/io/src/ui/delete_project_dialog.dart';
import 'package:paintroid/io/src/ui/project_details_dialog.dart';
import 'package:paintroid/main.dart';
import 'package:paintroid/ui/overflow_menu.dart';
import 'package:paintroid/ui/project_overflow_menu.dart';
import 'package:paintroid/ui/top_app_bar.dart';

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

  Project _createProject(String name) => Project(
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
        ProjectDatabase.provider.overrideWithValue(AsyncData(database)),
        IImageService.provider.overrideWithValue(imageService),
        IFileService.provider.overrideWithValue(fileService),
      ],
      child: const PocketPaintApp(),
    );
    projects = List.generate(5, (index) => _createProject('project$index'));
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
      final titleFinder = find.widgetWithText(AppBar, "Pocket Paint");
      expect(titleFinder, findsOneWidget);
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

      final okButton = find.widgetWithText(ElevatedButton, 'OK');
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
          find.widgetWithText(DeleteProjectDialog, 'Delete project$position');
      expect(deleteProjectDialog, findsOneWidget);
      expect(find.text('Do you really want to delete your project?'),
          findsOneWidget);
      final cancelButton = find.widgetWithText(ElevatedButton, 'Cancel');
      final deleteButton = find.widgetWithText(TextButton, 'Delete');
      expect(cancelButton, findsOneWidget);
      expect(deleteButton, findsOneWidget);
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();
      expect(deleteProjectDialog, findsNothing);
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

      final titleFinder = find.widgetWithText(TopAppBar, "Pocket Paint");
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
}
