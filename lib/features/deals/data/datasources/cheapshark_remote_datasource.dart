import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:broly_1_1/core/network/api_endpoints.dart';
import 'package:broly_1_1/features/deals/data/models/deal_model.dart';

class CheapSharkRemoteDataSource {
  final http.Client client;

  CheapSharkRemoteDataSource({http.Client? client})
      : client = client ?? http.Client();

  Future<List<DealModel>> getDeals({
    String? title,
    String sortBy = 'Savings',
    int pageSize = 20,
  }) async {
    final queryParams = {
      'sortBy': sortBy,
      'pageSize': pageSize.toString(),
      if (title != null && title.trim().isNotEmpty) 'title': title.trim(),
    };

    final uri = Uri.parse(ApiEndpoints.deals).replace(queryParameters: queryParams);

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => DealModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar ofertas de CheapShark: ${response.statusCode}');
    }
  }
}
