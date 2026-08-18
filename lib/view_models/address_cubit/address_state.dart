part of 'address_cubit.dart';

sealed class AddressState {}

final class AddressInitial extends AddressState {}

final class FetchingAddresses extends AddressState {}

final class AddressesFetched extends AddressState {
  final List<AddressModel> addresses;
  final AddressModel? selectedAddress;

  AddressesFetched({
    required this.addresses,
    this.selectedAddress,
  });

  AddressesFetched copyWith({
    List<AddressModel>? addresses,
    AddressModel? selectedAddress,
  }) {
    return AddressesFetched(
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
    );
  }
}

final class FailureFetchingAddresses extends AddressState {
  final String errorMessage;

  FailureFetchingAddresses(this.errorMessage);
}

final class AddingAddress extends AddressState {}

final class AddressAdded extends AddressState {
  final AddressModel newAddress;

  AddressAdded(this.newAddress);
}

final class AddingAddressFailed extends AddressState {
  final String errorMessage;

  AddingAddressFailed(this.errorMessage);
}
