import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConstants {
  /// Obtiene la URL de Supabase cargada de forma segura desde el archivo .env
  static String get url => dotenv.env['SUPABASE_URL'] ?? '';

  /// Obtiene la Publishable Key de Supabase desde el archivo .env
  static String get publishableKey =>
      dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ?? '';

  /// Alias de conveniencia
  static String get anonKey => publishableKey;
}
