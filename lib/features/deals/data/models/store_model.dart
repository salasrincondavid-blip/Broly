class StoreModel {
  final String storeID;
  final String storeName;
  final bool isActive;
  final String? banner;
  final String? logo;
  final String? icon;

  StoreModel({
    required this.storeID,
    required this.storeName,
    required this.isActive,
    this.banner,
    this.logo,
    this.icon,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      storeID: json['storeID']?.toString() ?? '',
      storeName: json['storeName'] ?? '',
      isActive: (json['isActive'] == 1 || json['isActive'] == true || json['isActive'] == '1'),
      banner: json['images']?['banner'],
      logo: json['images']?['logo'],
      icon: json['images']?['icon'],
    );
  }
}
