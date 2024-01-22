import 'package:database/src/models/project.dart';
import 'package:floor/floor.dart';

@dao
abstract class ProjectDAO {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertProject(Project project);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertProjects(List<Project> projects);

  @Query('DELETE FROM Project WHERE id = :id')
  Future<void> deleteProject(int id);

  @delete
  Future<void> deleteProjects(List<Project> projects);

  @Query('SELECT * FROM Project order by lastModified desc')
  Future<List<Project>> getProjects();

  @Query('SELECT * FROM Project WHERE name = :name')
  Future<Project?> getProjectByName(String name);
}
