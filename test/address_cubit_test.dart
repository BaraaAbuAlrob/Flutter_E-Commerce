import 'package:flutter_ecommerce_app/view_models/address_cubit/address_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AddressCubit Tests', () {
    late AddressCubit cubit;

    setUp(() {
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
      expect(cubit.state, isA<FetchingAddresses>());

      await Future.delayed(const Duration(milliseconds: 350));
      expect(cubit.state, isA<AddressesFetched>());

      final state = cubit.state as AddressesFetched;
      expect(state.addresses.isNotEmpty, isTrue);
      expect(state.selectedAddress, isNotNull);
    });

    test('selectAddress updates selectedAddress in AddressesFetched', () async {
      cubit.fetchAddresses();
      await Future.delayed(const Duration(milliseconds: 350));

      final state = cubit.state as AddressesFetched;
      final target = state.addresses.last;
      cubit.selectAddress(target);

      final updatedState = cubit.state as AddressesFetched;
      expect(updatedState.selectedAddress?.id, target.id);
    });

    test('addAddress adds new address, emits AddressAdded then AddressesFetched', () async {
      cubit.fetchAddresses();
      await Future.delayed(const Duration(milliseconds: 350));

      cubit.addAddress(
        city: 'Miami',
        country: 'United States',
        street: '100 Ocean Drive, Miami, FL',
        title: 'Beach House',
      );

      expect(cubit.state, isA<AddingAddress>());

      await Future.delayed(const Duration(milliseconds: 550));
      expect(cubit.state, isA<AddressesFetched>());

      final state = cubit.state as AddressesFetched;
      expect(state.selectedAddress?.city, 'Miami');
      expect(state.selectedAddress?.title, 'Beach House');
    });

    test('searchAddresses filters list appropriately', () async {
      cubit.fetchAddresses();
      await Future.delayed(const Duration(milliseconds: 350));

      cubit.searchAddresses('York');
      final searchState = cubit.state as AddressesFetched;
      expect(searchState.addresses.any((a) => a.city.contains('New York')), isTrue);
      expect(searchState.addresses.every((a) => a.city.contains('York') || a.country.contains('York')), isTrue);
    });
  });
}
