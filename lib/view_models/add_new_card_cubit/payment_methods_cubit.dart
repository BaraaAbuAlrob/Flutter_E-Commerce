import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/payment_card_model.dart';
import 'package:flutter_ecommerce_app/secrvices/local_storage_service.dart';

part 'payment_methods_state.dart';

class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  final LocalStorageService _localStorageService = LocalStorageService.instance;

  PaymentMethodsCubit() : super(PaymentMethodsInitial());

  void fetchPaymentMethods([PaymentCardModel? initialSelectedCard]) {
    emit(FetchingPaymentMethods());
    try {
      final paymentCards = _localStorageService.getCards();
      final selected = initialSelectedCard ??
          (paymentCards.isNotEmpty ? paymentCards.first : null);

      emit(
        FetchedPaymentMethods(
          paymentCards: paymentCards,
          selectedCard: selected,
        ),
      );
    } catch (e) {
      emit(FetchPaymentMethodsError('Failed to fetch payment methods: $e'));
    }
  }

  void selectPaymentCard(PaymentCardModel card) {
    if (state is FetchedPaymentMethods) {
      final currentState = state as FetchedPaymentMethods;
      emit(currentState.copyWith(selectedCard: card));
    }
  }

  Future<void> addNewCard(
    String cardNumber,
    String cardHolderName,
    String expiryDate,
    String cvv,
  ) async {
    emit(AddNewCardLoading());
    final newCard = PaymentCardModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cardNumber: cardNumber,
      cardHolderName: cardHolderName,
      expiryDate: expiryDate,
      cvv: cvv,
    );

    try {
      await _localStorageService.saveCard(newCard);
      emit(AddNewCardSuccess(newCard));
    } catch (e) {
      emit(AddNewCardFailure('Failed to save card: $e'));
    }
  }
}
