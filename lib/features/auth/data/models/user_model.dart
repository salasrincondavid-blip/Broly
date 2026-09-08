import 'package:broly_1_1/features/deals/data/models/deal_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final List<DealModel> favorites;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    List<DealModel>? favorites,
  }) : favorites = favorites ?? [];

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    List<DealModel>? favorites,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      favorites: favorites ?? List.from(this.favorites),
    );
  }
}
