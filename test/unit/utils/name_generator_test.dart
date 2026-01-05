import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:paintroid/core/database/project_dao.dart';
import 'package:paintroid/core/database/project_database.dart';
import 'package:paintroid/core/models/database/project.dart';
import 'package:paintroid/core/utils/name_generator.dart';

import 'name_generator_test.mocks.dart';

@GenerateMocks([ProjectDatabase, ProjectDAO])
void main() {
  group('NameGenerator', () {
    late MockProjectDatabase mockDatabase;
    late MockProjectDAO mockProjectDAO;

    setUp(() {
      mockDatabase = MockProjectDatabase();
      mockProjectDAO = MockProjectDAO();
      when(mockDatabase.projectDAO).thenReturn(mockProjectDAO);
    });

    group('getNextProjectName', () {
      test('Should return "project1" when no projects exist', () async {
        when(mockProjectDAO.getProjects()).thenAnswer((_) async => []);

        final result = await NameGenerator.getNextProjectName(mockDatabase);

        expect(result, 'project1');
        verify(mockProjectDAO.getProjects()).called(1);
      });

      test('Should return "project2" when "project1" exists', () async {
        final existingProject = Project(
          name: 'project1',
          path: '/path/to/project1',
          lastModified: DateTime.now(),
          creationDate: DateTime.now(),
        );
        when(mockProjectDAO.getProjects())
            .thenAnswer((_) async => [existingProject]);

        final result = await NameGenerator.getNextProjectName(mockDatabase);

        expect(result, 'project2');
        verify(mockProjectDAO.getProjects()).called(1);
      });

      test('Should return "project5" when projects 1-4 exist', () async {
        final projects = [
          Project(
            name: 'project1',
            path: '/path/to/project1',
            lastModified: DateTime.now(),
            creationDate: DateTime.now(),
          ),
          Project(
            name: 'project2',
            path: '/path/to/project2',
            lastModified: DateTime.now(),
            creationDate: DateTime.now(),
          ),
          Project(
            name: 'project3',
            path: '/path/to/project3',
            lastModified: DateTime.now(),
            creationDate: DateTime.now(),
          ),
          Project(
            name: 'project4',
            path: '/path/to/project4',
            lastModified: DateTime.now(),
            creationDate: DateTime.now(),
          ),
        ];
        when(mockProjectDAO.getProjects()).thenAnswer((_) async => projects);

        final result = await NameGenerator.getNextProjectName(mockDatabase);

        expect(result, 'project5');
      });

      test('Should find max number when projects are not sequential', () async {
        final projects = [
          Project(
            name: 'project1',
            path: '/path/to/project1',
            lastModified: DateTime.now(),
            creationDate: DateTime.now(),
          ),
          Project(
            name: 'project5',
            path: '/path/to/project5',
            lastModified: DateTime.now(),
            creationDate: DateTime.now(),
          ),
          Project(
            name: 'project3',
            path: '/path/to/project3',
            lastModified: DateTime.now(),
            creationDate: DateTime.now(),
          ),
        ];
        when(mockProjectDAO.getProjects()).thenAnswer((_) async => projects);

        final result = await NameGenerator.getNextProjectName(mockDatabase);

        expect(result, 'project6');
      });

      test('Should ignore projects with different naming patterns', () async {
        final projects = [
          Project(
            name: 'project1',
            path: '/path/to/project1',
            lastModified: DateTime.now(),
            creationDate: DateTime.now(),
          ),
          Project(
            name: 'myProject',
            path: '/path/to/myProject',
            lastModified: DateTime.now(),
            creationDate: DateTime.now(),
          ),
          Project(
            name: 'project3',
            path: '/path/to/project3',
            lastModified: DateTime.now(),
            creationDate: DateTime.now(),
          ),
          Project(
            name: 'test',
            path: '/path/to/test',
            lastModified: DateTime.now(),
            creationDate: DateTime.now(),
          ),
        ];
        when(mockProjectDAO.getProjects()).thenAnswer((_) async => projects);

        final result = await NameGenerator.getNextProjectName(mockDatabase);

        expect(result, 'project4');
      });

      test('Should handle large project numbers correctly', () async {
        final projects = [
          Project(
            name: 'project99',
            path: '/path/to/project99',
            lastModified: DateTime.now(),
            creationDate: DateTime.now(),
          ),
          Project(
            name: 'project100',
            path: '/path/to/project100',
            lastModified: DateTime.now(),
            creationDate: DateTime.now(),
          ),
        ];
        when(mockProjectDAO.getProjects()).thenAnswer((_) async => projects);

        final result = await NameGenerator.getNextProjectName(mockDatabase);

        expect(result, 'project101');
      });
    });

    group('getNextImageName', () {
      setUp(() {
        SharedPreferences.setMockInitialValues({});
      });

      test('Should return "image1" on first call', () async {
        final result = await NameGenerator.getNextImageName();

        expect(result, 'image1');
      });

      test('Should increment counter with each call', () async {
        final first = await NameGenerator.getNextImageName();
        expect(first, 'image1');

        final second = await NameGenerator.getNextImageName();
        expect(second, 'image2');

        final third = await NameGenerator.getNextImageName();
        expect(third, 'image3');
      });

      test('Should persist counter across instances', () async {
        await NameGenerator.getNextImageName();
        await NameGenerator.getNextImageName();

        final prefs = await SharedPreferences.getInstance();
        final savedValue = prefs.getInt('last_image_number');

        expect(savedValue, 2);
      });

      test('Should resume from stored counter value', () async {
        SharedPreferences.setMockInitialValues({'last_image_number': 42});

        final result = await NameGenerator.getNextImageName();

        expect(result, 'image43');
      });

      test('Should handle large numbers correctly', () async {
        SharedPreferences.setMockInitialValues({'last_image_number': 999});

        final result = await NameGenerator.getNextImageName();

        expect(result, 'image1000');
      });

      test('Should save incremented value to SharedPreferences', () async {
        SharedPreferences.setMockInitialValues({'last_image_number': 5});

        await NameGenerator.getNextImageName();

        final prefs = await SharedPreferences.getInstance();
        final savedValue = prefs.getInt('last_image_number');

        expect(savedValue, 6);
      });
    });
  });
}
