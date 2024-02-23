import 'dart:async';

import 'package:database/src/models/project.dart';
import 'package:database/src/project_dao.dart';
import 'package:database/src/utils/date_time_converter.dart';
import 'package:floor/floor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sqflite/sqflite.dart' as sqflite;

part 'project_database.g.dart';

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [Project])
abstract class ProjectDatabase extends FloorDatabase {
  ProjectDAO get projectDAO;

  static final provider = FutureProvider((ref) =>
      $FloorProjectDatabase.databaseBuilder('project_database.db').build());
}
