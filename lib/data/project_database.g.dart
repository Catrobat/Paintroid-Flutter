// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorProjectDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$ProjectDatabaseBuilder databaseBuilder(String name) =>
      _$ProjectDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$ProjectDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$ProjectDatabaseBuilder(null);
}

class _$ProjectDatabaseBuilder {
  _$ProjectDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$ProjectDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$ProjectDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<ProjectDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$ProjectDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$ProjectDatabase extends ProjectDatabase {
  _$ProjectDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ProjectDAO? _projectDAOInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Project` (`name` TEXT NOT NULL, `path` TEXT NOT NULL, `lastModified` INTEGER NOT NULL, `creationDate` INTEGER NOT NULL, `resolution` TEXT, `format` TEXT, `size` INTEGER, `imagePreviewPath` TEXT, `id` INTEGER PRIMARY KEY AUTOINCREMENT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ProjectDAO get projectDAO {
    return _projectDAOInstance ??= _$ProjectDAO(database, changeListener);
  }
}

class _$ProjectDAO extends ProjectDAO {
  _$ProjectDAO(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _projectInsertionAdapter = InsertionAdapter(
            database,
            'Project',
            (Project item) => <String, Object?>{
                  'name': item.name,
                  'path': item.path,
                  'lastModified': _dateTimeConverter.encode(item.lastModified),
                  'creationDate': _dateTimeConverter.encode(item.creationDate),
                  'resolution': item.resolution,
                  'format': item.format,
                  'size': item.size,
                  'imagePreviewPath': item.imagePreviewPath,
                  'id': item.id
                }),
        _projectDeletionAdapter = DeletionAdapter(
            database,
            'Project',
            ['id'],
            (Project item) => <String, Object?>{
                  'name': item.name,
                  'path': item.path,
                  'lastModified': _dateTimeConverter.encode(item.lastModified),
                  'creationDate': _dateTimeConverter.encode(item.creationDate),
                  'resolution': item.resolution,
                  'format': item.format,
                  'size': item.size,
                  'imagePreviewPath': item.imagePreviewPath,
                  'id': item.id
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Project> _projectInsertionAdapter;

  final DeletionAdapter<Project> _projectDeletionAdapter;

  @override
  Future<void> deleteProject(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Project WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<List<Project>> getProjects() async {
    return _queryAdapter.queryList(
        'SELECT * FROM Project order by lastModified desc',
        mapper: (Map<String, Object?> row) => Project(
            name: row['name'] as String,
            path: row['path'] as String,
            lastModified: _dateTimeConverter.decode(row['lastModified'] as int),
            creationDate: _dateTimeConverter.decode(row['creationDate'] as int),
            resolution: row['resolution'] as String?,
            format: row['format'] as String?,
            size: row['size'] as int?,
            imagePreviewPath: row['imagePreviewPath'] as String?,
            id: row['id'] as int?));
  }

  @override
  Future<int> insertProject(Project project) {
    return _projectInsertionAdapter.insertAndReturnId(
        project, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> insertProjects(List<Project> projects) {
    return _projectInsertionAdapter.insertListAndReturnIds(
        projects, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteProjects(List<Project> projects) async {
    await _projectDeletionAdapter.deleteList(projects);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
