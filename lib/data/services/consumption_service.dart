import 'package:macromiam/data/mappers/consumption_mapper.dart';
import 'package:macromiam/data/models/consumption_model.dart';
import 'package:macromiam/data/repositories/consumption_repository.dart';
import 'package:macromiam/data/services/aliment_service.dart';

import '../models/aliment_model.dart';

class ConsumptionService {
  final AlimentService alimentService;
  final ConsumptionRepository consumptionRepository;

  ConsumptionService({
    required this.alimentService,
    required this.consumptionRepository,
  });

  Future<void> saveConsumption({required ConsumptionModel consumption}) async {
    await consumptionRepository.saveConsumption(consumption: consumption);
  }

  Future<List<ConsumptionModel>> getConsumptions() async {
    final consumptionsMaps = await consumptionRepository.getConsumptions();

    final List<ConsumptionModel?> consumptions = await Future.wait(
      consumptionsMaps.map((elt) async {
        return await consumptionFromMap(map: elt);
      }),
    );

    return consumptions.whereType<ConsumptionModel>().toList();
  }

  Future<ConsumptionModel?> consumptionFromMap({
    required Map<String, dynamic> map,
  }) async {
    AlimentModel? aliment = await alimentService.alimentFromId(
      id: map['alimentId'],
    );
    if (aliment != null) {
      return ConsumptionMapper.consumptionModelFromMap(
        map: map,
        aliment: aliment,
      );
    }
    return null;
  }
}
