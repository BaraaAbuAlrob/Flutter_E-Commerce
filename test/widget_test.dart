import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/views/pages/checkout_page.dart';
import 'package:flutter_ecommerce_app/views/widgets/empty_shipping_payment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CheckoutPage initial state shows Add shipping address', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CheckoutPage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Checkout'), findsOneWidget);
    expect(find.text('Address'), findsOneWidget);
    expect(find.text('Add shipping address'), findsOneWidget);
    expect(find.byType(EmptyShippingAndPayment), findsWidgets);
  });
}
