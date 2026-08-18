part of 'checkout_cubit.dart';

sealed class CheckoutState {}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoading extends CheckoutState {}

final class CheckoutLoaded extends CheckoutState {
  final List<AddToCartModel> checkoutItems;
  final double totalAmount;
  final int numOfProducts;
  final PaymentCardModel? chosenPaymentCard;
  final AddressModel? chosenAddress;

  CheckoutLoaded({
    required this.checkoutItems,
    required this.totalAmount,
    required this.numOfProducts,
    required this.chosenPaymentCard,
    this.chosenAddress,
  });

  CheckoutLoaded copyWith({
    List<AddToCartModel>? checkoutItems,
    double? totalAmount,
    int? numOfProducts,
    PaymentCardModel? chosenPaymentCard,
    AddressModel? chosenAddress,
  }) {
    return CheckoutLoaded(
      checkoutItems: checkoutItems ?? this.checkoutItems,
      totalAmount: totalAmount ?? this.totalAmount,
      numOfProducts: numOfProducts ?? this.numOfProducts,
      chosenPaymentCard: chosenPaymentCard ?? this.chosenPaymentCard,
      chosenAddress: chosenAddress ?? this.chosenAddress,
    );
  }
}

final class CheckoutError extends CheckoutState {
  final String message;

  CheckoutError({required this.message});
}
