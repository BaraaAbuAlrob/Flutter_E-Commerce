import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/view_models/address_cubit/address_cubit.dart';
import 'package:flutter_ecommerce_app/views/pages/address_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('AddressPage renders properly and displays addresses', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (context) => AddressCubit()..fetchAddresses(),
          child: const AddressPage(),
        ),
      ),
    );

    // Wait for fetching delay
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    expect(find.text('Choose your location'), findsOneWidget);
    expect(find.text('Select location'), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);
    expect(find.text('Los Angeles'), findsWidgets);

    // Tap on San Francisco
    final sfFinder = find.text('San Francisco');
    if (sfFinder.evaluate().isNotEmpty) {
      await tester.tap(sfFinder.first);
      await tester.pumpAndSettle();
    }

    // Tap on Confirm
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();
  });
}
