import 'aliment_model.dart';
import 'enums_model.dart';

class ConsumptionModel {
  int? id;
  AlimentModel? aliment;
  double? quantityInGrams;
  MealType mealType;
  DayOfWeek dayOfWeek;

  ConsumptionModel({
    required this.id,
    required this.aliment,
    required this.quantityInGrams,
    required this.mealType,
    required this.dayOfWeek,
  });

  Map<String, dynamic> toMap() {
    return {
      "alimentId": aliment!.id,
      "quantityInGrams": quantityInGrams,
      "mealType": mealType.label,
      "dayOfWeek": dayOfWeek.label,
    };
  }

  @override
  String toString() {
    return 'ConsumptionModel{id: $id, aliment: $aliment, quantityInGrams: $quantityInGrams, mealType: $mealType, dayOfWeek: $dayOfWeek}';
  }
}
