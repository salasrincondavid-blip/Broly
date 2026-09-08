import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:broly_1_1/features/deals/data/models/deal_model.dart';
import 'package:broly_1_1/features/deals/presentation/screens/deal_details_screen.dart';

void main() {
  testWidgets('DealDetailsScreen displays game information and store button', (WidgetTester tester) async {
    final deal = DealModel(
      dealID: 'test1234',
      title: 'Cyberpunk 2077',
      salePrice: '29.99',
      normalPrice: '59.99',
      savings: '50',
      thumb: 'https://example.com/thumb.jpg',
      steamRatingPercent: '88',
      dealRating: '9.2',
      storeID: '1',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: DealDetailsScreen(deal: deal),
      ),
    );

    // Verify Title and pricing are shown
    expect(find.text('Cyberpunk 2077'), findsOneWidget);
    expect(find.text('\$29.99 USD'), findsOneWidget);
    expect(find.text('\$59.99'), findsOneWidget);
    expect(find.text('-50% DESCUENTO'), findsOneWidget);
    expect(find.text('88%'), findsOneWidget);
    expect(find.text('9.2 / 10'), findsOneWidget);

    // Verify Call-to-action button
    expect(find.text('Ir a la tienda oficial para comparar'), findsOneWidget);
  });
}
