import 'dart:io';

import 'package:database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_library/io_library.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oxidized/oxidized.dart';
import 'package:search_bar_screen/src/search_screen.dart';

import 'search_bar_screen_test.mocks.dart';

@GenerateMocks([ProjectDatabase, ProjectDAO, IImageService])
void main() {
  const filePath = 'test/fixture/image/test.jpg';
  final testFile = File(filePath);
  final date = DateTime.now();
  late List<Project> projects;
  late Widget sut;
  late ProjectDatabase database;
  late ProjectDAO dao;
  late IImageService imageService;

  Project createProject(String name) => Project(
      name: name,
      path: filePath,
      imagePreviewPath: filePath,
      lastModified: date,
      creationDate: date,
    );

  setUp(() {
    database = MockProjectDatabase();
    dao = MockProjectDAO();
    imageService = MockIImageService();
    sut = ProviderScope(
          overrides: [
            ProjectDatabase.provider.overrideWith((ref) => Future.value(database)),
            IImageService.provider.overrideWith((ref) => imageService),
          ],
          child: const MaterialApp(
            home: SearchScreen()
          ) 
        );
    projects = List.generate(5, (index) => createProject('Project $index'));
        
  });

  testWidgets(
    'Should display the project searched', 
    (tester) async {
      when(database.projectDAO).thenReturn(dao);
      when(dao.getProjects()).thenAnswer((_) => Future.value(projects));
      when(imageService.getProjectPreview(filePath))
          .thenReturn(Result.ok(testFile.readAsBytesSync()));

      await tester.pumpWidget(sut);
      await tester.pumpAndSettle();

      verify(database.projectDAO);
      verify(dao.getProjects());
      
      var searchBar = find.widgetWithText(TextField, 'Search...');
      expect(searchBar, findsOneWidget);
      
      await tester.enterText(searchBar, '1');
      await tester.pumpAndSettle();
      expect(find.text('Project 1'), findsOneWidget);

      await tester.enterText(searchBar, '2');
      await tester.pumpAndSettle();
      expect(find.text('Project 2'), findsOneWidget);

      await tester.enterText(searchBar, '10');
      await tester.pumpAndSettle();
      expect(find.text('Project 10'), findsNothing);

      await tester.enterText(searchBar, 'Project');
      await tester.pumpAndSettle();
      for(int i = 0; i<5; i++) {
        expect(find.text('Project $i'), findsOneWidget);
      }
    },
  );
}