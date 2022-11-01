import 'dart:async';

import 'package:floor/floor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/data/model/project.dart';
import 'package:paintroid/data/project_dao.dart';
import 'package:paintroid/data/typeconverters/date_time_converter.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'project_database.g.dart';

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [Project])
abstract class ProjectDatabase extends FloorDatabase {
  ProjectDAO get projectDAO;

  static final provider = FutureProvider((ref) =>
      $FloorProjectDatabase.databaseBuilder("project_database.db").build());
}
