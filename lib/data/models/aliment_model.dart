class AlimentModel {
  final int? id;
  final String name;
  final double protein;
  final double carbohydrates;
  final double fat;
  final double calories;
  final String? path;

  AlimentModel({
    this.id,
    required this.name,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
    required this.calories,
    required this.path,
  });

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'protein': protein,
      'carbohydrates': carbohydrates,
      'fat': fat,
      'calories': calories,
      'path': path,
    };
  }

  factory AlimentModel.fromMap(Map<String, dynamic> aliment) {
    return AlimentModel(
      id: aliment['id'],
      name: aliment['name'],
      protein: aliment['protein'],
      carbohydrates: aliment['carbohydrates'],
      fat: aliment['fat'],
      calories: aliment['calories'],
      path: aliment['path'],
    );
  }

  @override
  String toString() {
    return 'CustomAlimentModel{id: $id, name: $name, protein: $protein, carbohydrates: $carbohydrates, fat: $fat, calories: $calories, path: $path}';
  }
}
