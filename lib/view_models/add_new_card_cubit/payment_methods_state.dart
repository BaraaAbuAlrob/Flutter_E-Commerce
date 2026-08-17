part of 'payment_methods_cubit.dart';

sealed class PaymentMethodsState {}

final class PaymentMethodsInitial extends PaymentMethodsState {}

final class AddNewCardLoading extends PaymentMethodsState {}

final class AddNewCardSuccess extends PaymentMethodsState {
  final PaymentCardModel newCard;

  AddNewCardSuccess(this.newCard);
}

final class AddNewCardFailure extends PaymentMethodsState {
  final String errorMessage;

  AddNewCardFailure(this.errorMessage);
}

final class FetchingPaymentMethods extends PaymentMethodsState {}

final class FetchedPaymentMethods extends PaymentMethodsState {
  final List<PaymentCardModel> paymentCards;
  final PaymentCardModel? selectedCard;

  FetchedPaymentMethods({
    required this.paymentCards,
    this.selectedCard,
  });

  FetchedPaymentMethods copyWith({
    List<PaymentCardModel>? paymentCards,
    PaymentCardModel? selectedCard,
  }) {
    return FetchedPaymentMethods(
      paymentCards: paymentCards ?? this.paymentCards,
      selectedCard: selectedCard ?? this.selectedCard,
    );
  }
}

final class FetchPaymentMethodsError extends PaymentMethodsState {
  final String errorMessage;

  FetchPaymentMethodsError(this.errorMessage);
}
