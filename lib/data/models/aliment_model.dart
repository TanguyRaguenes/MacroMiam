class AlimentModel {
  final int? id;
  final String name;
  final double proteins;
  final double carbohydrates;
  final double fat;
  final double calories;
  final String? imageSource;

  AlimentModel({
    this.id,
    required this.name,
    required this.proteins,
    required this.carbohydrates,
    required this.fat,
    required this.calories,
    required this.imageSource,
  });

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'proteins': proteins,
      'carbohydrates': carbohydrates,
      'fat': fat,
      'calories': calories,
      'imageSource': imageSource,
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
      imageSource: aliment['imageSource'],
    );
  }

  factory AlimentModel.fromAlimentModelApi({
    required String name,
    required double proteins,
    required double carbohydrates,
    required double fat,
    required double calories,
    required String? imageSource,
  }) {
    return AlimentModel(
      name: name,
      proteins: proteins,
      carbohydrates: carbohydrates,
      fat: fat,
      calories: calories,
      imageSource: imageSource,
    );
  }

  @override
  String toString() {
    return 'CustomAlimentModel{id: $id, name: $name, protein: $proteins, carbohydrates: $carbohydrates, fat: $fat, calories: $calories, imageSource: $imageSource}';
  }
}
