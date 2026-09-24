import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/models/address_model.dart';
import 'package:flutter_ecommerce_app/models/payment_card_model.dart';
import 'package:flutter_ecommerce_app/secrvices/local_storage_service.dart';
import 'package:flutter_ecommerce_app/views/widgets/address_card_item.dart';
import 'package:flutter_ecommerce_app/views/widgets/payment_method_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test_widget');
    Hive.init(tempDir.path);
    await Hive.openBox<Map>(LocalStorageService.cardsBoxName);
    await Hive.openBox<Map>(LocalStorageService.addressesBoxName);
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  testWidgets('AddressCardItem and PaymentMethodItem render properly', (WidgetTester tester) async {
    const address = AddressModel(
      id: '1',
      city: 'New York',
      country: 'USA',
      title: 'Home',
    );

    final card = PaymentCardModel(
      id: '1',
      cardNumber: '1234567890123456',
      cardHolderName: 'Test User',
      expiryDate: '12/28',
      cvv: '123',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              AddressCardItem(
                address: address,
                onTap: () {},
              ),
              PaymentMethodItem(
                paymentCard: card,
                onItemTapped: () {},
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(AddressCardItem), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('New York, USA'), findsOneWidget);
    expect(find.byType(PaymentMethodItem), findsOneWidget);
    expect(find.text('Test User • Exp 12/28'), findsOneWidget);
  });
}
