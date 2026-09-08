import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:broly_1_1/core/constants/supabase_constants.dart';
import 'package:broly_1_1/core/theme/app_theme.dart';
import 'package:broly_1_1/features/auth/presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de Supabase
  if (SupabaseConstants.url.startsWith('https://') &&
      !SupabaseConstants.url.contains('TU_PROYECTO') &&
      !SupabaseConstants.publishableKey.contains('TU_SUPABASE_ANON_KEY')) {
    await Supabase.initialize(
      url: SupabaseConstants.url,
      // ignore: deprecated_member_use
      anonKey: SupabaseConstants.publishableKey,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CheapShark Deals App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LoginScreen(),
    );
  }
}
