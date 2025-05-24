import 'package:macromiam/data/models/consumption_model.dart';

import '../services/sqlite_db_service.dart';

class ConsumptionRepository {
  final SqliteDbService sqliteDbService;

  ConsumptionRepository({required this.sqliteDbService});

  Future<void> saveConsumption({required ConsumptionModel consumption}) async {
    sqliteDbService.saveConsumption(consumption);
  }

  Future<List<Map<String, dynamic>>> getConsumptions() async {
    return await sqliteDbService.getConsumptions();
  }
}
