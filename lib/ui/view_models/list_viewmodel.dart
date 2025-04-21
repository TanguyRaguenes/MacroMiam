import 'package:flutter/cupertino.dart';

import '../../data/models/aliment_model.dart';
import '../../data/repositories/aliment_repository.dart';

class ListViewModel extends ChangeNotifier {
  ListViewModel({required AlimentRepository alimentRepository}) {
    _alimentRepository = alimentRepository;
    getAliments();
  }

  late final AlimentRepository _alimentRepository;

  List<AlimentModel> _aliments = [];

  List<AlimentModel> get aliments => _aliments;

  Future<void> getAliments() async {
    final List<Map<String, dynamic>> maps =
        await _alimentRepository.getAliments();
    _aliments = List.generate(maps.length, (i) {
      return AlimentModel.fromMap(maps[i]);
    });
    notifyListeners();
  }

  Future<void> deleteAliment(int id) async {
    await _alimentRepository.deleteAliment(id);
    await getAliments();
  }
}
