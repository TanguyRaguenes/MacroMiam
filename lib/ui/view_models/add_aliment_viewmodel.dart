import 'package:flutter/material.dart';
import '../../data/models/textformfield_model.dart';
import '../../data/repositories/aliment_repository.dart';

import '../../data/models/aliment_model.dart';

class AddAlimentViewModel {
  AddAlimentViewModel({required AlimentRepository alimentRepository}) {
    _alimentRepository = alimentRepository;
  }

  late final AlimentRepository _alimentRepository;

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

    await _alimentRepository.saveAliment(aliment);
  }
}
