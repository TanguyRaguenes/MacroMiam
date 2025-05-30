import 'dart:ui';

import '../../providers/locale_provider.dart';

class AlimentApiModel {
  String? id;

  String? imageFrontUrl;
  String? imageIngredientsUrl;
  String? imageNutritionUrl;

  Map<String, dynamic>? nutriments;
  String? productName;

  AlimentApiModel({
    required this.id,
    required this.imageFrontUrl,
    required this.imageIngredientsUrl,
    required this.imageNutritionUrl,
    required this.nutriments,
    required this.productName,
  });

  @override
  String toString() {
    return 'AlimentApiModel{id: $id, imageFrontUrl: $imageFrontUrl, imageIngredientsUrl: $imageIngredientsUrl, imageNutritionUrl: $imageNutritionUrl, nutriments: $nutriments, productName: $productName}';
  }

  factory AlimentApiModel.fromMap(Map<String, dynamic> apiData) {
    final LocaleProvider localeProvider = LocaleProvider();
    String languageCode = localeProvider.locale.languageCode;
    return AlimentApiModel(
      id: apiData['_id'],
      imageFrontUrl:
          apiData['selected_images']['front']['display'][languageCode] ??
          apiData['image_front_url'],
      imageIngredientsUrl:
          apiData['selected_images']['ingredients']['display'][languageCode] ??
          apiData['image_ingredients_url'],
      imageNutritionUrl:
          apiData['selected_images']['nutrition']['display'][languageCode] ??
          apiData['image_nutrition_url'],
      nutriments: apiData['nutriments'],
      productName: apiData['product_name'],
    );
  }
}
