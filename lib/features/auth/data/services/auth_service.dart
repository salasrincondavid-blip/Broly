import 'package:flutter/material.dart';
import 'package:broly_1_1/features/auth/data/models/user_model.dart';
import 'package:broly_1_1/features/deals/data/models/deal_model.dart';

class AuthService extends ChangeNotifier {
  static final AuthService instance = AuthService._internal();

  AuthService._internal() {
    // Usuario por defecto en memoria
    _currentUser = UserModel(
      id: 'usr_001',
      name: 'Gamer Legendario',
      email: 'gamer@broly.com',
      favorites: [],
    );
  }

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  List<DealModel> get favorites => _currentUser?.favorites ?? [];

  /// Inicia sesión con credenciales en memoria (o cualquier correo/clave para pruebas)
  bool login(String email, String password) {
    if (email.trim().isNotEmpty && password.trim().isNotEmpty) {
      _currentUser = UserModel(
        id: 'usr_001',
        name: email.contains('@') ? email.split('@').first : email,
        email: email,
        favorites: _currentUser?.favorites ?? [],
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Cierra sesión en memoria
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  /// Verifica si una oferta está en la lista de favoritos del usuario
  bool isFavorite(String dealID) {
    if (_currentUser == null) return false;
    return _currentUser!.favorites.any((d) => d.dealID == dealID);
  }

  /// Añade o elimina una oferta de la lista de favoritos en memoria
  bool toggleFavorite(DealModel deal) {
    if (_currentUser == null) return false;

    final exists = isFavorite(deal.dealID);
    final updatedFavorites = List<DealModel>.from(_currentUser!.favorites);

    if (exists) {
      updatedFavorites.removeWhere((d) => d.dealID == deal.dealID);
    } else {
      updatedFavorites.add(deal);
    }

    _currentUser = _currentUser!.copyWith(favorites: updatedFavorites);
    notifyListeners();
    return !exists; // Devuelve true si fue añadido, false si fue removido
  }
}
