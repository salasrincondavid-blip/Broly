class DealModel {
  final String dealID;
  final String title;
  final String salePrice;
  final String normalPrice;
  final String savings;
  final String thumb;
  final String steamRatingPercent;
  final String dealRating;
  final String storeID;

  DealModel({
    required this.dealID,
    required this.title,
    required this.salePrice,
    required this.normalPrice,
    required this.savings,
    required this.thumb,
    required this.steamRatingPercent,
    required this.dealRating,
    required this.storeID,
  });

  factory DealModel.fromJson(Map<String, dynamic> json) {
    return DealModel(
      dealID: json['dealID'] ?? '',
      title: json['title'] ?? 'Sin título',
      salePrice: json['salePrice'] ?? '0.00',
      normalPrice: json['normalPrice'] ?? '0.00',
      savings: double.tryParse(json['savings']?.toString() ?? '0')
              ?.toStringAsFixed(0) ??
          '0',
      thumb: json['thumb'] ?? '',
      steamRatingPercent: json['steamRatingPercent'] ?? '0',
      dealRating: json['dealRating'] ?? '0',
      storeID: json['storeID'] ?? '1',
    );
  }

  Map<String, dynamic> toSupabaseMap(String userId) {
    return {
      'user_id': userId,
      'deal_id': dealID,
      'title': title,
      'sale_price': salePrice,
      'normal_price': normalPrice,
      'savings': savings,
      'thumb': thumb,
      'steam_rating_percent': steamRatingPercent,
      'deal_rating': dealRating,
      'store_id': storeID,
    };
  }

  factory DealModel.fromSupabaseMap(Map<String, dynamic> map) {
    return DealModel(
      dealID: map['deal_id'] ?? '',
      title: map['title'] ?? 'Sin título',
      salePrice: map['sale_price'] ?? '0.00',
      normalPrice: map['normal_price'] ?? '0.00',
      savings: map['savings']?.toString() ?? '0',
      thumb: map['thumb'] ?? '',
      steamRatingPercent: map['steam_rating_percent'] ?? '0',
      dealRating: map['deal_rating'] ?? '0',
      storeID: map['store_id'] ?? '1',
    );
  }
}
