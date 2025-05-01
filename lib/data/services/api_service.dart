import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:macromiam/data/models/aliment_api_model.dart';

class ApiService {
  Future<AlimentApiModel?> fetchData({required String url}) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> decoded = jsonDecode(response.body);
      Map<String, dynamic> product = decoded['product'];

      AlimentApiModel aliment = AlimentApiModel.fromMap(product);
      return aliment;
    }

    return null;
  }
}
