import 'package:flutter_test/flutter_test.dart';
import 'package:broly_1_1/main.dart';
import 'package:broly_1_1/features/auth/presentation/screens/login_screen.dart';

void main() {
  testWidgets('App loads LoginScreen smoke test', (WidgetTester tester) async {
    // Construir la app y renderizar el primer frame.
    await tester.pumpWidget(const MyApp());

    // Verificar que LoginScreen se renderice con su título y campos.
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('¡Bienvenido Gamer!'), findsOneWidget);
    expect(find.text('Iniciar Sesión'), findsOneWidget);
  });
}

