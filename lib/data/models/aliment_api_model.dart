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
    return AlimentApiModel(
      id: apiData['_id'],
      imageFrontUrl: apiData['selected_images']['front']['small']['en'],
      imageIngredientsUrl:
          apiData['selected_images']['ingredients']['small']['en'],
      imageNutritionUrl: apiData['selected_images']['nutrition']['small']['en'],
      nutriments: apiData['nutriments'],
      productName: apiData['product_name'],
    );
  }
}
