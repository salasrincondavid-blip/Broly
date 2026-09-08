import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:broly_1_1/core/constants/supabase_constants.dart';
import 'package:broly_1_1/features/auth/data/models/user_model.dart';
import 'package:broly_1_1/features/deals/data/models/deal_model.dart';

class AuthService extends ChangeNotifier {
  static final AuthService instance = AuthService._internal();

  AuthService._internal() {
    _initSupabaseListener();
  }

  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  List<DealModel> get favorites => _currentUser?.favorites ?? [];

  bool get isSupabaseConfigured {
    return SupabaseConstants.url.startsWith('https://') &&
        !SupabaseConstants.url.contains('TU_PROYECTO') &&
        !SupabaseConstants.anonKey.contains('TU_SUPABASE_ANON_KEY');
  }

  SupabaseClient? get _client {
    if (!isSupabaseConfigured) return null;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  void _initSupabaseListener() {
    if (!isSupabaseConfigured) {
      // Si aún no está configurado Supabase, inicializamos un usuario de prueba en memoria
      _currentUser = UserModel(
        id: 'usr_001',
        name: 'Gamer Legendario (Modo Local)',
        email: 'gamer@broly.com',
        favorites: [],
      );
      return;
    }

    try {
      final client = _client;
      if (client == null) return;

      // Escuchar cambios de sesión (login, logout, refresh de token)
      client.auth.onAuthStateChange.listen((data) async {
        final session = data.session;
        if (session != null) {
          await _loadUserProfile(session.user);
        } else {
          _currentUser = null;
          notifyListeners();
        }
      });
    } catch (e) {
      developer.log('Error inicializando listener de Supabase: $e', name: 'AuthService');
    }
  }

  /// Carga el perfil del usuario desde la tabla 'profiles' y sus favoritos de 'user_favorites'
  Future<void> _loadUserProfile(User user) async {
    final client = _client;
    if (client == null) return;

    try {
      // 1. Obtener perfil de la base de datos SQL
      final profileResponse = await client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      // 2. Obtener ofertas favoritas guardadas
      final favoritesResponse = await client
          .from('user_favorites')
          .select()
          .eq('user_id', user.id);

      final List<DealModel> userFavorites = (favoritesResponse as List<dynamic>?)
              ?.map((item) => DealModel.fromSupabaseMap(item as Map<String, dynamic>))
              .toList() ??
          [];

      final name = profileResponse?['name'] ??
          user.userMetadata?['name'] ??
          (user.email != null ? user.email!.split('@').first : 'Gamer');

      _currentUser = UserModel(
        id: user.id,
        name: name.toString(),
        email: user.email ?? '',
        avatarUrl: profileResponse?['avatar_url']?.toString(),
        favorites: userFavorites,
      );

      notifyListeners();
    } catch (e) {
      developer.log('Error cargando perfil desde Supabase: $e', name: 'AuthService');
    }
  }

  /// Inicia sesión con Supabase Auth (o en memoria si no está configurado)
  /// Retorna `null` si el inicio fue exitoso, o el mensaje de error si falló.
  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final client = _client;
      if (client == null) {
        // Modo local de prueba
        await Future.delayed(const Duration(milliseconds: 300));
        _currentUser = UserModel(
          id: 'usr_001',
          name: email.contains('@') ? email.split('@').first : email,
          email: email,
          favorites: _currentUser?.favorites ?? [],
        );
        _isLoading = false;
        notifyListeners();
        return null;
      }

      final response = await client.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (response.user != null) {
        await _loadUserProfile(response.user!);
      }

      _isLoading = false;
      notifyListeners();
      return null;
    } on AuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Ocurrió un error inesperado al iniciar sesión: $e';
    }
  }

  /// Registra un nuevo usuario con Supabase Auth y guarda sus datos en PostgreSQL
  /// Retorna `null` si fue exitoso, o el mensaje de error.
  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final client = _client;
      if (client == null) {
        // Modo local de prueba
        await Future.delayed(const Duration(milliseconds: 300));
        _currentUser = UserModel(
          id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
          name: name,
          email: email,
          favorites: [],
        );
        _isLoading = false;
        notifyListeners();
        return null;
      }

      final response = await client.auth.signUp(
        email: email.trim(),
        password: password.trim(),
        data: {'name': name.trim()},
      );

      if (response.user != null) {
        // Asegurar que el perfil quede guardado en profiles
        try {
          await client.from('profiles').upsert({
            'id': response.user!.id,
            'name': name.trim(),
            'updated_at': DateTime.now().toIso8601String(),
          });
        } catch (_) {}

        await _loadUserProfile(response.user!);
      }

      _isLoading = false;
      notifyListeners();
      return null;
    } on AuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Ocurrió un error inesperado al registrar la cuenta: $e';
    }
  }

  /// Cierra sesión en Supabase y limpia el estado local
  Future<void> logout() async {
    final client = _client;
    if (client != null) {
      try {
        await client.auth.signOut();
      } catch (e) {
        developer.log('Error cerrando sesión en Supabase: $e', name: 'AuthService');
      }
    }
    _currentUser = null;
    notifyListeners();
  }

  /// Actualiza los datos del perfil (nombre o avatar) en Supabase SQL
  Future<bool> updateProfile({required String name, String? avatarUrl}) async {
    if (_currentUser == null) return false;

    _currentUser = _currentUser!.copyWith(
      name: name,
      avatarUrl: avatarUrl ?? _currentUser!.avatarUrl,
    );
    notifyListeners();

    final client = _client;
    if (client != null) {
      try {
        await client.from('profiles').update({
          'name': name,
          'avatar_url': ?avatarUrl,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', _currentUser!.id);
        return true;
      } catch (e) {
        developer.log('Error actualizando perfil en Supabase: $e', name: 'AuthService');
        return false;
      }
    }
    return true;
  }

  /// Verifica si una oferta está en la lista de favoritos del usuario
  bool isFavorite(String dealID) {
    if (_currentUser == null) return false;
    return _currentUser!.favorites.any((d) => d.dealID == dealID);
  }

  /// Añade o elimina una oferta en la base de datos SQL de Supabase (user_favorites)
  /// y actualiza la UI de manera reactiva e inmediata (Optimistic UI)
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

    // Sincronizar en segundo plano con la base de datos de Supabase
    final client = _client;
    final userId = _currentUser!.id;

    if (client != null) {
      _syncFavoriteWithDatabase(client, userId, deal, exists);
    }

    return !exists; // True si fue añadido, false si fue removido
  }

  Future<void> _syncFavoriteWithDatabase(
    SupabaseClient client,
    String userId,
    DealModel deal,
    bool wasExisting,
  ) async {
    try {
      if (wasExisting) {
        // Eliminar de Supabase SQL
        await client
            .from('user_favorites')
            .delete()
            .match({'user_id': userId, 'deal_id': deal.dealID});
      } else {
        // Insertar en Supabase SQL
        await client.from('user_favorites').insert(deal.toSupabaseMap(userId));
      }
    } catch (e) {
      developer.log('Error sincronizando favorito en Supabase: $e', name: 'AuthService');
    }
  }
}
