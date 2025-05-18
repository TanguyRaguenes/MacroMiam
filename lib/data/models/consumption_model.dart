import 'aliment_model.dart';
import 'enums_model.dart';

class ConsumptionModel {
  final AlimentModel? aliment;
  final double quantityInGrams;
  MealType mealType;
  DayOfWeek dayOfWeek;

  ConsumptionModel({
    required this.aliment,
    required this.quantityInGrams,
    required this.mealType,
    required this.dayOfWeek,
  });

  @override
  String toString() {
    return 'ConsumptionModel{aliment: $aliment, quantityInGrams: $quantityInGrams, mealType: $mealType, dayOfWeek: $dayOfWeek}';
  }
}
