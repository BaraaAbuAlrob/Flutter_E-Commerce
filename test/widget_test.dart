import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/views/pages/checkout_page.dart';
import 'package:flutter_ecommerce_app/views/widgets/address_card_item.dart';
import 'package:flutter_ecommerce_app/views/widgets/payment_method_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CheckoutPage renders properly and displays address and payment', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CheckoutPage(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Checkout'), findsOneWidget);
    expect(find.text('Address'), findsOneWidget);
    expect(find.byType(AddressCardItem), findsOneWidget);
    expect(find.text('Payment'), findsOneWidget);
    expect(find.byType(PaymentMethodItem), findsOneWidget);
  });
}
