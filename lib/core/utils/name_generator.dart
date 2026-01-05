import 'package:shared_preferences/shared_preferences.dart';

import 'package:paintroid/core/database/project_database.dart';

class NameGenerator {
  static const String _imageCounterKey = 'last_image_number';

  /// Finds the next available project name in format "project[number]"
  /// by querying the database for existing projects
  static Future<String> getNextProjectName(ProjectDatabase database) async {
    final projects = await database.projectDAO.getProjects();
    return _findNextAvailableName(
      projects.map((p) => p.name).toList(),
      'project',
    );
  }

  /// Finds the next available image name in format "image[number]"
  /// Uses SharedPreferences to track the counter since images are saved
  /// to the photo library where we can't query filenames
  static Future<String> getNextImageName() async {
    final prefs = await SharedPreferences.getInstance();
    final lastNumber = prefs.getInt(_imageCounterKey) ?? 0;
    final nextNumber = lastNumber + 1;
    await prefs.setInt(_imageCounterKey, nextNumber);
    return 'image$nextNumber';
  }

  /// Finds the next available name by parsing existing names with the given prefix
  /// Returns prefix + (maxNumber + 1)
  static String _findNextAvailableName(List<String> existingNames, String prefix) {
    final pattern = RegExp('^$prefix(\\d+)\$');
    int maxNumber = 0;

    for (final name in existingNames) {
      final match = pattern.firstMatch(name);
      if (match != null) {
        final number = int.tryParse(match.group(1)!);
        if (number != null && number > maxNumber) {
          maxNumber = number;
        }
      }
    }

    return '$prefix${maxNumber + 1}';
  }
}
