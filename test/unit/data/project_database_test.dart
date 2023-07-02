import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paintroid/data/model/project.dart';
import 'package:paintroid/data/project_database.dart';
import 'package:paintroid/data/typeconverters/date_time_converter.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  late final ProjectDatabase database;
  late final List<Project> projectList;
  late final DateTime date;

  setUpAll(() async {
    database =
        await $FloorProjectDatabase.databaseBuilder("test_database.db").build();
    projectList = [];
    date =
        DateTimeConverter().decode(DateTimeConverter().encode(DateTime.now()));
  });

  Project _createProject(String name) => Project(
        name: name,
        path: "testPath",
        lastModified: date,
        creationDate: date,
      );

  test('Should provide valid Database', () async {
    final container = ProviderContainer();
    container
        .read(ProjectDatabase.provider)
        .whenData((db) => expect(db, isA<ProjectDatabase>));
  });

  test('Should insert the project to the database', () async {
    Project project = _createProject("testProject");
    projectList.add(project);
    final result = await database.projectDAO.insertProject(project);
    expect(result, isA<int>());
  });

  test('Should insert the projects to the database', () async {
    List<Project> projects = [];
    for (int i = 1; i <= 5; i++) {
      final project = _createProject("test$i");
      projects.add(project);
      projectList.add(project);
    }
    final result = await database.projectDAO.insertProjects(projects);
    expect(result, isA<List<int>>());
  });

  test('Should fetch the saved projects from the database', () async {
    final projects = await database.projectDAO.getProjects();
    final len = projects.length;

    expect(len, projectList.length);
    for (int i = 0; i < len; i++) {
      final actualProject = projects[i];
      final expectedProject = projectList[i];
      expect(actualProject.name, expectedProject.name);
      expect(actualProject.path, expectedProject.path);
      expect(actualProject.lastModified, expectedProject.lastModified);
      expect(actualProject.creationDate, expectedProject.creationDate);
      expect(actualProject.resolution, expectedProject.resolution);
      expect(actualProject.format, expectedProject.format);
      expect(actualProject.size, expectedProject.size);
      expect(actualProject.imagePreviewPath, expectedProject.imagePreviewPath);
      expect(actualProject.id, isA<int>());
    }
  });

  test('Should delete the project from the database', () async {
    List<Project> projects = await database.projectDAO.getProjects();
    final project = projects[3];
    projectList.removeAt(3);
    await database.projectDAO.deleteProject(project.id!);

    projects = await database.projectDAO.getProjects();
    final len = projects.length;
    expect(len, projectList.length);

    for (int i = 0; i < len; i++) {
      final actualProject = projects[i];
      final expectedProject = projectList[i];
      expect(actualProject.name, expectedProject.name);
      expect(actualProject.path, expectedProject.path);
      expect(actualProject.lastModified, expectedProject.lastModified);
      expect(actualProject.creationDate, expectedProject.creationDate);
      expect(actualProject.resolution, expectedProject.resolution);
      expect(actualProject.format, expectedProject.format);
      expect(actualProject.size, expectedProject.size);
      expect(actualProject.imagePreviewPath, expectedProject.imagePreviewPath);
      expect(actualProject.id, isA<int>());
    }
  });

  test('Should delete all the projects from the database', () async {
    var projects = await database.projectDAO.getProjects();
    await database.projectDAO.deleteProjects(projects);
    projects = await database.projectDAO.getProjects();
    expect(projects.length, 0);
  });

  tearDownAll(() async {
    projectList.clear();
  });
}
