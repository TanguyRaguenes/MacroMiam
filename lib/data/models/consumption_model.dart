import 'aliment_model.dart';
import 'enums_model.dart';

class ConsumptionModel {
  AlimentModel? aliment;
  double quantityInGrams;
  MealType mealType;
  DayOfWeek dayOfWeek;

  ConsumptionModel({
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
    return 'ConsumptionModel{aliment: $aliment, quantityInGrams: $quantityInGrams, mealType: $mealType, dayOfWeek: $dayOfWeek}';
  }
}
