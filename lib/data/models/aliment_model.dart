class AlimentModel {
  final int? id;
  final String name;
  final double proteins;
  final double carbohydrates;
  final double fat;
  final double calories;
  final String? pathOrUrl;

  AlimentModel({
    this.id,
    required this.name,
    required this.proteins,
    required this.carbohydrates,
    required this.fat,
    required this.calories,
    required this.pathOrUrl,
  });

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'proteins': proteins,
      'carbohydrates': carbohydrates,
      'fat': fat,
      'calories': calories,
      'pathOrUrl': pathOrUrl,
    };
  }

  factory AlimentModel.fromMap(Map<String, dynamic> aliment) {
    return AlimentModel(
      id: aliment['id'],
      name: aliment['name'],
      proteins: aliment['proteins'],
      carbohydrates: aliment['carbohydrates'],
      fat: aliment['fat'],
      calories: aliment['calories'],
      pathOrUrl: aliment['pathOrUrl'],
    );
  }

  factory AlimentModel.fromAlimentModelApi({
    required String name,
    required double proteins,
    required double carbohydrates,
    required double fat,
    required double calories,
    required String? pathOrUrl,
  }) {
    return AlimentModel(
      name: name,
      proteins: proteins,
      carbohydrates: carbohydrates,
      fat: fat,
      calories: calories,
      pathOrUrl: pathOrUrl,
    );
  }

  @override
  String toString() {
    return 'CustomAlimentModel{id: $id, name: $name, protein: $proteins, carbohydrates: $carbohydrates, fat: $fat, calories: $calories, pathOrUrl: $pathOrUrl}';
  }
}
