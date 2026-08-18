import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/payment_card_model.dart';

part 'payment_methods_state.dart';

class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  PaymentMethodsCubit() : super(PaymentMethodsInitial());

  void fetchPaymentMethods([PaymentCardModel? initialSelectedCard]) {
    if (state is FetchedPaymentMethods) {
      if (dummyPaymentCards.isNotEmpty) {
        final selected = initialSelectedCard ?? dummyPaymentCards.last;
        emit(
          FetchedPaymentMethods(
            paymentCards: List.from(dummyPaymentCards),
            selectedCard: selected,
          ),
        );
      } else {
        emit(FetchPaymentMethodsError('No payment methods found'));
      }
      return;
    }

    emit(FetchingPaymentMethods());
    Future.delayed(const Duration(milliseconds: 300), () {
      if (dummyPaymentCards.isNotEmpty) {
        final selected = initialSelectedCard ?? dummyPaymentCards.first;
        emit(
          FetchedPaymentMethods(
            paymentCards: List.from(dummyPaymentCards),
            selectedCard: selected,
          ),
        );
      } else {
        emit(FetchPaymentMethodsError('No payment methods found'));
      }
    });
  }

  void selectPaymentCard(PaymentCardModel card) {
    if (state is FetchedPaymentMethods) {
      final currentState = state as FetchedPaymentMethods;
      emit(currentState.copyWith(selectedCard: card));
    }
  }

  void addNewCard(
    String cardNumber,
    String cardHolderName,
    String expiryDate,
    String cvv,
  ) {
    emit(AddNewCardLoading());
    final newCard = PaymentCardModel(
      id: DateTime.now().toIso8601String(),
      cardNumber: cardNumber,
      cardHolderName: cardHolderName,
      expiryDate: expiryDate,
      cvv: cvv,
    );
    Future.delayed(const Duration(seconds: 1), () {
      dummyPaymentCards.add(newCard);
      emit(AddNewCardSuccess(newCard));
    });
  }
}
