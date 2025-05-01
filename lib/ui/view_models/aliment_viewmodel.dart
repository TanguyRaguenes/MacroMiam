import 'package:flutter/cupertino.dart';
import 'package:macromiam/data/models/aliment_api_model.dart';

class AlimentViewModel extends ChangeNotifier {
  AlimentApiModel? _alimentApiModel;

  AlimentApiModel? get alimentApiModel {
    return _alimentApiModel;
  }

  set alimentApiModel(AlimentApiModel? alimentApiModel) {
    _alimentApiModel = alimentApiModel;
    notifyListeners();
  }
}
