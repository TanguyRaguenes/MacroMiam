import 'package:flutter/material.dart';
import 'package:macromiam/data/models/consumption_model.dart';
import 'package:macromiam/data/services/consumption_service.dart';

import '../../data/models/enums_model.dart';

class ConsumptionVm extends ChangeNotifier {
  final ConsumptionService consumptionService;

  List<ConsumptionModel> _consumptions = [];

  List<ConsumptionModel> get consumptions => _consumptions;

  set consumptions(List<ConsumptionModel> value) {
    _consumptions = value;
    notifyListeners();
  }

  ConsumptionVm({required this.consumptionService});

  Future<void> getConsumptions() async {
    _consumptions = await consumptionService.getConsumptions();
    notifyListeners();
  }

  Future<void> saveConsumption({required ConsumptionModel consumption}) async {
    await consumptionService.saveConsumption(consumption: consumption);
    getConsumptions();
  }

  List<ConsumptionModel> filterConsumptions({
    required DayOfWeek day,
    required MealType? meal,
  }) {
    List<ConsumptionModel> consumptionsFiltered = [];
    if (meal != null) {
      consumptionsFiltered =
          _consumptions
              .where((elt) => elt.dayOfWeek == day && elt.mealType == meal)
              .toList();
    } else {
      consumptionsFiltered =
          _consumptions.where((elt) => elt.dayOfWeek == day).toList();
    }

    return consumptionsFiltered;
  }

  Future<void> deleteConsumption({required int id}) async {
    await consumptionService.deleteConsumption(id: id);
    getConsumptions();
  }

  Widget getNutriments({required List<ConsumptionModel> consumptions}) {
    int proteins = 0;
    int carbohydrates = 0;
    int fat = 0;
    int calories = 0;

    for (ConsumptionModel consumption in consumptions) {
      double qty = consumption.quantityInGrams! / 100;
      proteins += (consumption.aliment!.proteins * qty).round();
      carbohydrates += (consumption.aliment!.carbohydrates * qty).round();
      fat += (consumption.aliment!.fat * qty).round();
      calories += (consumption.aliment!.calories * qty).round();
    }

    if (proteins == 0 && carbohydrates == 0 && fat == 0 && calories == 0) {
      return Text('');
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black),
        children: [
          TextSpan(
            text: 'prot: $proteins',
            style: TextStyle(color: Colors.red),
          ),
          TextSpan(text: ' | '),
          TextSpan(
            text: 'carb: $carbohydrates ',
            style: TextStyle(color: Colors.green),
          ),
          TextSpan(text: ' | '),
          TextSpan(text: 'fat: $fat', style: TextStyle(color: Colors.blue)),
          TextSpan(text: ' | '),
          TextSpan(
            text: 'cal: $calories',
            style: TextStyle(color: Colors.amber),
          ),
        ],
      ),
    );
  }
}
