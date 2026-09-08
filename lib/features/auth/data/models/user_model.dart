import 'package:broly_1_1/features/deals/data/models/deal_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final List<DealModel> favorites;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    List<DealModel>? favorites,
  }) : favorites = favorites ?? [];

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    List<DealModel>? favorites,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      favorites: favorites ?? List.from(this.favorites),
    );
  }

  factory UserModel.fromSupabaseProfile({
    required Map<String, dynamic> profileMap,
    required String email,
    List<DealModel>? favorites,
  }) {
    return UserModel(
      id: profileMap['id']?.toString() ?? '',
      name: profileMap['name']?.toString() ?? email.split('@').first,
      email: email,
      avatarUrl: profileMap['avatar_url']?.toString(),
      favorites: favorites ?? [],
    );
  }

  Map<String, dynamic> toProfileMap() {
    return {
      'id': id,
      'name': name,
      'avatar_url': ?avatarUrl,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}
