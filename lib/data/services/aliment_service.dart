import 'package:macromiam/data/mappers/aliment_mapper.dart';
import 'package:macromiam/data/models/aliment_model.dart';
import 'package:macromiam/data/repositories/aliment_repository.dart';

class AlimentService {
  final AlimentRepository alimentRepository;

  AlimentService({required this.alimentRepository});

  AlimentModel alimentFromMap({required Map<String, dynamic> map}) {
    return AlimentMapper.alimentFromMap(alimentMap: map);
  }

  Future<AlimentModel?> alimentFromId({required int id}) async {
    Map<String, dynamic>? alimentMap = await alimentRepository.getAlimentById(
      id: id,
    );
    if (alimentMap != null && alimentMap.isNotEmpty) {
      return AlimentMapper.alimentFromMap(alimentMap: alimentMap);
    }
    return null;
  }
}
