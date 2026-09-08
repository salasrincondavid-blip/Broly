import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:broly_1_1/core/network/api_endpoints.dart';
import 'package:broly_1_1/features/deals/data/models/deal_model.dart';
import 'package:broly_1_1/features/deals/data/models/store_model.dart';

class CheapSharkRemoteDataSource {
  final http.Client client;

  CheapSharkRemoteDataSource({http.Client? client})
      : client = client ?? http.Client();

  Future<List<StoreModel>> getStores() async {
    final uri = Uri.parse(ApiEndpoints.stores);
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map((json) => StoreModel.fromJson(json))
          .where((store) => store.isActive)
          .toList();
    } else {
      throw Exception('Error al cargar tiendas: ${response.statusCode}');
    }
  }

  Future<List<DealModel>> getDeals({
    String? title,
    double? lowerPrice,
    double? upperPrice,
    List<String>? storeIDs,
    double? minDiscount,
    String sortBy = 'Savings',
    int pageSize = 30,
  }) async {
    final queryParams = <String, String>{
      'sortBy': sortBy,
      'pageSize': pageSize.toString(),
      if (title != null && title.trim().isNotEmpty) 'title': title.trim(),
      if (lowerPrice != null) 'lowerPrice': lowerPrice.toInt().toString(),
      if (upperPrice != null && upperPrice < 100) 'upperPrice': upperPrice.toInt().toString(),
      if (storeIDs != null && storeIDs.isNotEmpty) 'storeID': storeIDs.join(','),
    };

    final uri = Uri.parse(ApiEndpoints.deals).replace(queryParameters: queryParams);

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      var deals = jsonList.map((json) => DealModel.fromJson(json)).toList();

      if (minDiscount != null && minDiscount > 0) {
        deals = deals.where((deal) {
          final savingsVal = double.tryParse(deal.savings) ?? 0.0;
          return savingsVal >= minDiscount;
        }).toList();
      }

      return deals;
    } else {
      throw Exception('Error al cargar ofertas de CheapShark: ${response.statusCode}');
    }
  }
}

