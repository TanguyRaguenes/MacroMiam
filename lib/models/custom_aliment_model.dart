class CustomAlimentModel {
  final String name;
  final double protein;
  final double carbohydrates;
  final double fat;
  final double calories;

  CustomAlimentModel({
    required this.name,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
    required this.calories,
  });

  Map<String, Object> toMap() {
    return {
      'name': name,
      'protein': protein,
      'carbohydrates': carbohydrates,
      'fat': fat,
      'calories': calories,
    };
  }

  factory CustomAlimentModel.fromMap(Map<String, dynamic> aliment) {
    return CustomAlimentModel(
      name: aliment['name'],
      protein: aliment['protein'],
      carbohydrates: aliment['carbohydrates'],
      fat: aliment['fat'],
      calories: aliment['calories'],
    );
  }

  @override
  String toString() {
    return 'CustomAlimentModel{name: $name, protein: $protein, carbohydrates: $carbohydrates, fat: $fat, calories: $calories}';
  }
}
