import 'dart:io';
import 'package:flutter/cupertino.dart';

import '../../data/repositories/aliment_repository.dart';
import '../../data/models/aliment_model.dart';
import 'package:file_picker/file_picker.dart';

class AddAlimentViewModel extends ChangeNotifier {
  AddAlimentViewModel({required AlimentRepository alimentRepository}) {
    _alimentRepository = alimentRepository;
  }

  late final AlimentRepository _alimentRepository;

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
}
