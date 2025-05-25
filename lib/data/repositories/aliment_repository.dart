import '../models/aliment_model.dart';
import '../services/sqlite_db_service.dart';

class AlimentRepository {
  final SqliteDbService sqliteDbService;

  AlimentRepository({required this.sqliteDbService});

  Future<void> saveAliment(AlimentModel aliment) async {
    if (aliment.id == null) {
      await sqliteDbService.saveAliment(aliment);
    } else {
      await sqliteDbService.updateAliment(aliment: aliment);
    }
  }

  Future<List<Map<String, dynamic>>> getAliments() async {
    return await sqliteDbService.getAliments();
  }

  Future<Map<String, dynamic>?> getAlimentById({required int id}) async {
    Map<String, dynamic>? alimentMap = await sqliteDbService.getAlimentById(
      id: id,
    );
    return alimentMap;
  }

  Future<void> deleteAliment({
    required int id,
    required String? imageSource,
  }) async {
    await sqliteDbService.deleteAliment(id);
  }
}
