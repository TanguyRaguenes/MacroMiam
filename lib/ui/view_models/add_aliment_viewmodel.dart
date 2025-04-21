import 'package:flutter/material.dart';
import '../../data/models/textformfield_model.dart';
import '../../data/repositories/add_aliment_repository.dart';

import '../../data/models/aliment_model.dart';

class AddAlimentViewModel {
  AddAlimentViewModel({required AddAlimentRepository addAlimentRepository}) {
    _addAlimentRepository = addAlimentRepository;
  }

  late final AddAlimentRepository _addAlimentRepository;

  Future<void> saveAliment(
    String name,
    String protein,
    String carbohydrates,
    String fat,
    String calories,
  ) async {
    final aliment = AlimentModel(
      name: name,
      protein: double.tryParse(protein) ?? 0.0,
      carbohydrates: double.tryParse(carbohydrates) ?? 0.0,
      fat: double.tryParse(fat) ?? 0.0,
      calories: double.tryParse(calories) ?? 0.0,
    );

    await _addAlimentRepository.saveAliment(aliment);
  }
}
