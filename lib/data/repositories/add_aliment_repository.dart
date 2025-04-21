import '../models/aliment_model.dart';
import '../services/sqlite_db_service.dart';

class AddAlimentRepository {
  AddAlimentRepository({required SqliteDbService sqliteDbService}) {
    _sqliteDbService = sqliteDbService;
  }

  late final SqliteDbService _sqliteDbService;

  Future<void> saveAliment(AlimentModel aliment) async {
    await _sqliteDbService.insertAliment(aliment);
  }
}
