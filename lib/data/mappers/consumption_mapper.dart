import 'package:macromiam/data/models/aliment_model.dart';
import 'package:macromiam/data/models/enums_model.dart';

import '../models/consumption_model.dart';

class ConsumptionMapper {
  static Future<ConsumptionModel> consumptionModelFromMap({
    required Map<String, dynamic> map,
    required AlimentModel aliment,
  }) async {
    return ConsumptionModel(
      id: map['id'],
      aliment: aliment,
      quantityInGrams: map['quantityInGrams'],
      mealType: MealTypeExtension.fromLabel(map['mealType']),
      dayOfWeek: DayOfWeekExtension.fromLabel(map['dayOfWeek']),
    );
  }
}
