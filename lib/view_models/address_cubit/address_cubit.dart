import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/address_model.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit() : super(AddressInitial());

  static const List<Color> _pinColors = [
    Color(0xFF00D2B4), // Teal
    Color(0xFF7E57C2), // Purple
    Color(0xFFFF5252), // Coral Red
    Color(0xFFFF7043), // Orange
    Color(0xFF42A5F5), // Blue
    Color(0xFF26A69A), // Mint
    Color(0xFFEC407A), // Pink
  ];

  Color getRandomPinColor() {
    final random = Random();
    return _pinColors[random.nextInt(_pinColors.length)];
  }

  void fetchAddresses([AddressModel? initialSelectedAddress]) {
    if (state is AddressesFetched) {
      if (dummyAddresses.isNotEmpty) {
        final selected =
            initialSelectedAddress ??
            (state as AddressesFetched).selectedAddress ??
            dummyAddresses.first;
        emit(
          AddressesFetched(
            addresses: List.from(dummyAddresses),
            selectedAddress: selected,
          ),
        );
      } else {
        emit(FailureFetchingAddresses('No addresses found'));
      }
      return;
    }

    emit(FetchingAddresses());
    Future.delayed(const Duration(milliseconds: 300), () {
      if (dummyAddresses.isNotEmpty) {
        final selected = initialSelectedAddress ?? dummyAddresses.first;
        emit(
          AddressesFetched(
            addresses: List.from(dummyAddresses),
            selectedAddress: selected,
          ),
        );
      } else {
        emit(FailureFetchingAddresses('No addresses found'));
      }
    });
  }

  void selectAddress(AddressModel address) {
    if (state is AddressesFetched) {
      final currentState = state as AddressesFetched;
      emit(currentState.copyWith(selectedAddress: address));
    }
  }

  void addAddress({
    required String city,
    required String country,
    String? street,
    String? title,
    Color? pinColor,
  }) {
    emit(AddingAddress());

    if (city.trim().isEmpty || country.trim().isEmpty) {
      emit(AddingAddressFailed('City and Country cannot be empty'));
      return;
    }

    final newAddress = AddressModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      city: city.trim(),
      country: country.trim(),
      street: street?.trim(),
      title: (title != null && title.trim().isNotEmpty)
          ? title.trim()
          : city.trim(),
      pinColor: pinColor ?? getRandomPinColor(),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      dummyAddresses.insert(0, newAddress);
      emit(AddressAdded(newAddress));
      emit(
        AddressesFetched(
          addresses: List.from(dummyAddresses),
          selectedAddress: newAddress,
        ),
      );
    });
  }

  void searchAddresses(String query) {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) {
      emit(
        AddressesFetched(
          addresses: List.from(dummyAddresses),
          selectedAddress: (state is AddressesFetched)
              ? (state as AddressesFetched).selectedAddress
              : (dummyAddresses.isNotEmpty ? dummyAddresses.first : null),
        ),
      );
      return;
    }

    final filtered = dummyAddresses.where((item) {
      final matchesCity = item.city.toLowerCase().contains(cleanQuery);
      final matchesCountry = item.country.toLowerCase().contains(cleanQuery);
      final matchesStreet =
          item.street?.toLowerCase().contains(cleanQuery) ?? false;
      final matchesTitle =
          item.title?.toLowerCase().contains(cleanQuery) ?? false;
      return matchesCity || matchesCountry || matchesStreet || matchesTitle;
    }).toList();

    emit(
      AddressesFetched(
        addresses: filtered,
        selectedAddress: (state is AddressesFetched)
            ? (state as AddressesFetched).selectedAddress
            : (filtered.isNotEmpty ? filtered.first : null),
      ),
    );
  }
}
