import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:macromiam/data/models/aliment_api_model.dart';
import 'package:macromiam/data/services/api_service.dart';
import 'package:macromiam/data/services/image_service.dart';

import '../../data/models/aliment_model.dart';
import '../../data/repositories/aliment_repository.dart';

class AlimentVm extends ChangeNotifier {
  final AlimentRepository alimentRepository;
  final ApiService apiService;
  final ImageService imageService;
  File? persistentImage;
  XFile? previousCacheImage;

  AlimentVm({
    required this.alimentRepository,
    required this.apiService,
    required this.imageService,
  });

  AlimentModel? _alimentModel;

  AlimentModel? getAlimentModel() {
    return _alimentModel;
  }

  void setAlimentModel(AlimentModel? alimentModel) {
    _alimentModel = alimentModel;
    notifyListeners();
  }

  AlimentApiModel? _alimentApiModel;

  AlimentApiModel? getAlimentApiModel() {
    return _alimentApiModel;
  }

  void setAlimentApiModel(AlimentApiModel? alimentApiModel) {
    _alimentApiModel = alimentApiModel;
    notifyListeners();
  }

  Future<void> saveAliment({
    required int? id,
    required String name,
    required String protein,
    required String carbohydrates,
    required String fat,
    required String calories,
    required XFile? cacheImage,
    required String? imageSource,
  }) async {
    if (cacheImage != null) {
      if (cacheImage != previousCacheImage) {
        previousCacheImage = cacheImage;
        persistentImage = await imageService.saveImage(cacheImage: cacheImage);
        await imageService.clearCache();
      }
    } else {
      persistentImage = null;
    }

    final aliment = AlimentModel(
      id: id,
      name: name,
      proteins: double.tryParse(protein) ?? 0.0,
      carbohydrates: double.tryParse(carbohydrates) ?? 0.0,
      fat: double.tryParse(fat) ?? 0.0,
      calories: double.tryParse(calories) ?? 0.0,
      imageSource: persistentImage?.path ?? imageSource,
    );

    await alimentRepository.saveAliment(aliment);

    if (imageSource != null) {
      await imageService.deleteImage(imageSource: imageSource);
    }
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
