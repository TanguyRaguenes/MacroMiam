import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:macromiam/data/models/aliment_api_model.dart';
import 'package:macromiam/data/services/api_service.dart';
import 'package:macromiam/ui/view_models/aliment_viewmodel.dart';
import 'package:path/path.dart';

import '../../data/repositories/aliment_repository.dart';
import '../../data/models/aliment_model.dart';
import 'package:file_picker/file_picker.dart';

class AddAlimentViewModel extends ChangeNotifier {
  AddAlimentViewModel({
    required AlimentRepository alimentRepository,
    required ApiService apiService,
  }) {
    _alimentRepository = alimentRepository;
    _apiService = apiService;
  }

  late final AlimentRepository _alimentRepository;
  late final ApiService _apiService;

  bool _isCameraVisible = false;

  bool get isCameraVisible => _isCameraVisible;

  set isCameraVisible(bool boolean) {
    _isCameraVisible = boolean;
    notifyListeners();
  }

  String? _imagePath;

  String? get imagePath => _imagePath;

  set imagePath(String? path) {
    _imagePath = path;
    notifyListeners();
  }

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
      path: _imagePath,
    );

    await _alimentRepository.saveAliment(aliment);
  }

  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      _imagePath = File(result.files.single.path!).path;
      notifyListeners();
    }
  }

  void toggleIsCameraVisible() {
    _isCameraVisible = !_isCameraVisible;
    notifyListeners();
  }

  void disposeState() {
    _isCameraVisible = false;
    _imagePath = null;
  }

  Future<void> fetchData({
    required AlimentViewModel alimentViewModel,
    required String barcode,
  }) async {
    AlimentApiModel? aliment = await _apiService.fetchData(
      url: "https://world.openfoodfacts.org/api/v2/product/$barcode.json",
    );
    print(aliment.toString());

    alimentViewModel.alimentApiModel = aliment;
  }
}
