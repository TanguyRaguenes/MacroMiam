import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macromiam/data/models/aliment_api_model.dart';
import 'package:macromiam/data/services/api_service.dart';
import '../../data/repositories/aliment_repository.dart';
import '../../data/models/aliment_model.dart';

class AlimentVm extends ChangeNotifier {
  final AlimentRepository alimentRepository;
  final ApiService apiService;

  AlimentVm({required this.alimentRepository, required this.apiService});

  AlimentApiModel? _alimentApiModel;

  AlimentApiModel? getAlimentApiModel() {
    return _alimentApiModel;
  }

  void setAlimentApiModel(AlimentApiModel? alimentApiModel) {
    _alimentApiModel = alimentApiModel;
    notifyListeners();
  }

  Future<void> saveAliment({
    required String name,
    required String protein,
    required String carbohydrates,
    required String fat,
    required String calories,
    required String imagePath,
  }) async {
    final aliment = AlimentModel(
      name: name,
      protein: double.tryParse(protein) ?? 0.0,
      carbohydrates: double.tryParse(carbohydrates) ?? 0.0,
      fat: double.tryParse(fat) ?? 0.0,
      calories: double.tryParse(calories) ?? 0.0,
      path: imagePath,
    );

    await alimentRepository.saveAliment(aliment);
  }

  Future<AlimentApiModel?> fetchData({required String barcode}) async {
    try {
      AlimentApiModel? aliment = await apiService.fetchData(
        url: "https://world.openfoodfacts.org/api/v2/product/$barcode.json",
      );
      return aliment;
    } catch (e) {
      return null;
    }
  }
}
