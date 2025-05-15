import 'dart:io';

import 'package:path/path.dart' as path;

import '../models/aliment_model.dart';
import '../services/sqlite_db_service.dart';

class AlimentRepository {
  AlimentRepository({required SqliteDbService sqliteDbService}) {
    _sqliteDbService = sqliteDbService;
  }

  late final SqliteDbService _sqliteDbService;

  Future<void> saveAliment(AlimentModel aliment) async {
    if (aliment.id == null) {
      await _sqliteDbService.saveAliment(aliment);
    } else {
      await _sqliteDbService.updateAliment(aliment);
    }
  }

  Future<List<Map<String, dynamic>>> getAliments() async {
    return await _sqliteDbService.getAliments();
  }

  Future<void> deleteAliment({
    required int id,
    required String? imageSource,
  }) async {
    await _sqliteDbService.deleteAliment(id);
  }
}
