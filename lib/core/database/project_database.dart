import 'dart:async';

import 'package:floor/floor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:paintroid/core/database/project_dao.dart';
import 'package:paintroid/core/models/database/project.dart';
import 'package:paintroid/core/utils/date_time_converter.dart';

part 'project_database.g.dart';

String databaseName = 'project_database.db';

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [Project])
abstract class ProjectDatabase extends FloorDatabase {
  ProjectDAO get projectDAO;

  static final provider = FutureProvider((ref) =>
      $FloorProjectDatabase.databaseBuilder('project_database.db').build());
}
