import 'dart:io';
import 'package:flutter_ecommerce_app/models/address_model.dart';
import 'package:flutter_ecommerce_app/secrvices/local_storage_service.dart';
import 'package:flutter_ecommerce_app/view_models/address_cubit/address_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test_address');
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

  group('AddressCubit Tests', () {
    late AddressCubit cubit;

    setUp(() async {
      final box = Hive.box<Map>(LocalStorageService.addressesBoxName);
      await box.clear();
      cubit = AddressCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('Initial state is AddressInitial', () {
      expect(cubit.state, isA<AddressInitial>());
    });

    test('fetchAddresses emits FetchingAddresses then AddressesFetched', () async {
      cubit.fetchAddresses();
      expect(cubit.state, isA<AddressesFetched>());
    });

    test('addAddress adds new address, emits AddressAdded then AddressesFetched', () async {
      await cubit.addAddress(
        city: 'Miami',
        country: 'United States',
        street: '100 Ocean Drive, Miami, FL',
        title: 'Beach House',
      );

      expect(cubit.state, isA<AddressesFetched>());
      final state = cubit.state as AddressesFetched;
      expect(state.addresses.isNotEmpty, isTrue);
      expect(state.selectedAddress?.city, 'Miami');
      expect(state.selectedAddress?.title, 'Beach House');
    });

    test('selectAddress updates selectedAddress in AddressesFetched', () async {
      const address1 = AddressModel(id: '1', city: 'City1', country: 'Country1');
      const address2 = AddressModel(id: '2', city: 'City2', country: 'Country2');
      await LocalStorageService.instance.saveAddress(address1);
      await LocalStorageService.instance.saveAddress(address2);

      cubit.fetchAddresses();
      cubit.selectAddress(address2);

      final updatedState = cubit.state as AddressesFetched;
      expect(updatedState.selectedAddress?.id, '2');
    });

    test('searchAddresses filters list appropriately', () async {
      const address1 = AddressModel(id: '1', city: 'New York', country: 'USA');
      const address2 = AddressModel(id: '2', city: 'Chicago', country: 'USA');
      await LocalStorageService.instance.saveAddress(address1);
      await LocalStorageService.instance.saveAddress(address2);

      cubit.searchAddresses('York');
      final searchState = cubit.state as AddressesFetched;
      expect(searchState.addresses.length, 1);
      expect(searchState.addresses.first.city, 'New York');
    });
  });
}
