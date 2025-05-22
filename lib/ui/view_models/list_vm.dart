import 'package:flutter/cupertino.dart';
import 'package:macromiam/data/services/image_service.dart';
import '../../data/models/aliment_model.dart';
import '../../data/repositories/aliment_repository.dart';

class ListVm extends ChangeNotifier {
  final AlimentRepository alimentRepository;
  final ImageService imageService;

  ListVm({required this.alimentRepository, required this.imageService});

  List<AlimentModel> _aliments = [];
  List<AlimentModel> _alimentsBackup = [];

  List<AlimentModel> get aliments => _aliments;

  Future<void> fetchAliments() async {
    final List<Map<String, dynamic>> maps =
        await alimentRepository.getAliments();
    _alimentsBackup = List.generate(maps.length, (i) {
      return AlimentModel.fromMap(maps[i]);
    });
    _aliments = List.from(_alimentsBackup);
    notifyListeners();
  }

  Future<void> deleteAliment({
    required int id,
    required String? imageSource,
  }) async {
    await alimentRepository.deleteAliment(id: id, imageSource: imageSource);
    if (imageSource != null) {
      await imageService.deleteImage(imageSource: imageSource);
    }
    await fetchAliments();
  }

  Future<void> filterList(String input) async {
    List<AlimentModel> filteredList =
        _alimentsBackup
            .where((aliment) => aliment.name.toUpperCase().contains(input.toUpperCase()))
            .toList();
    _aliments = List.from(filteredList);
    notifyListeners();
  }
}
