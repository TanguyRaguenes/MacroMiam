import 'package:flutter/cupertino.dart';

import '../../data/models/aliment_model.dart';
import '../../data/repositories/aliment_repository.dart';

class ListViewModel extends ChangeNotifier {
  ListViewModel({required AlimentRepository alimentRepository}) {
    _alimentRepository = alimentRepository;
  }

  late final AlimentRepository _alimentRepository;

  List<AlimentModel> _aliments = [];
  List<AlimentModel> _alimentsBackup = [];

  List<AlimentModel> get aliments => _aliments;

  Future<void> getAliments() async {
    final List<Map<String, dynamic>> maps =
        await _alimentRepository.getAliments();
    _alimentsBackup = List.generate(maps.length, (i) {
      return AlimentModel.fromMap(maps[i]);
    });
    _aliments = List.from(_alimentsBackup);
    notifyListeners();
  }

  Future<void> deleteAliment(int id) async {
    await _alimentRepository.deleteAliment(id);
    await getAliments();
  }

  Future<void> filterList(String input) async {
    List<AlimentModel> filteredList =
        _alimentsBackup
            .where((aliment) => aliment.name.contains(input))
            .toList();
    _aliments = List.from(filteredList);
    notifyListeners();
  }
}
