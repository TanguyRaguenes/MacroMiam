import '../models/aliment_model.dart';

class AlimentMapper {
  static AlimentModel alimentFromMap({
    required Map<String, dynamic> alimentMap,
  }) {
    return AlimentModel(
      id: alimentMap['id'],
      name: alimentMap['name'],
      proteins: alimentMap['proteins'],
      carbohydrates: alimentMap['carbohydrates'],
      fat: alimentMap['fat'],
      calories: alimentMap['calories'],
      imageSource: alimentMap['imageSource'],
    );
  }

  // static AlimentModel alimentFromApi({
  //   required String name,
  //   required double proteins,
  //   required double carbohydrates,
  //   required double fat,
  //   required double calories,
  //   required String? imageSource,
  // }) {
  //   return AlimentModel(
  //     name: name,
  //     proteins: proteins,
  //     carbohydrates: carbohydrates,
  //     fat: fat,
  //     calories: calories,
  //     imageSource: imageSource,
  //   );
  // }
}
