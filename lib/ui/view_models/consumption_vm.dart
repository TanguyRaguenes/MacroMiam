import 'package:flutter/widgets.dart';
import 'package:macromiam/data/models/consumption_model.dart';
import 'package:macromiam/data/services/consumption_service.dart';

class ConsumptionVm extends ChangeNotifier {
  final ConsumptionService consumptionService;

  ConsumptionVm({required this.consumptionService});

  Future<List<ConsumptionModel>> getConsumptions() async {
    return await consumptionService.getConsumptions();
  }

  Future<void> saveConsumption({required ConsumptionModel consumption}) async {
    consumptionService.saveConsumption(consumption: consumption);
  }
}
