import 'package:macromiam/data/models/aliment_model.dart';
import 'package:macromiam/data/models/consumption_model.dart';

import '../../data/models/enums_model.dart';

class ConsumptionVm {
  Future<void> saveConsumption(
    AlimentModel aliment,
    double quantityInGrams,
    DayOfWeek dayOfWeek,
    MealType mealType,
  ) async {
    ConsumptionModel consumptionModel = ConsumptionModel(
      aliment: aliment,
      quantityInGrams: quantityInGrams,
      mealType: mealType,
      dayOfWeek: dayOfWeek,
    );
    print('///////////////////////////////////////////////////////');
    print(consumptionModel.toString());
    print('///////////////////////////////////////////////////////');
  }
}
