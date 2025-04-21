import '../models/aliment_model.dart';
import '../services/sqlite_db_service.dart';

class AlimentRepository {
  AlimentRepository({required SqliteDbService sqliteDbService}) {
    _sqliteDbService = sqliteDbService;
  }

  late final SqliteDbService _sqliteDbService;

  Future<void> saveAliment(AlimentModel aliment) async {
    await _sqliteDbService.saveAliment(aliment);
  }

  Future<List<Map<String, dynamic>>> getAliments() async {
    return await _sqliteDbService.getAliments();
  }

  Future<void> deleteAliment(int id) async {
    await _sqliteDbService.deleteAliment(id);
  }
}
