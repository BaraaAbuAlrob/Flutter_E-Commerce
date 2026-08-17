import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/models/payment_card_model.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  void getCartItems() {
    emit(CheckoutLoading());
    final checkoutItems = dummyCart.where((item) => item.isSelected).toList();
    final subtotal = checkoutItems.fold(
      0.0,
      (previousValue, element) =>
          previousValue + (element.product.price * element.quantity),
    );
    final numOfProducts = checkoutItems.fold(
      0,
      (previousValue, element) => previousValue + element.quantity,
    );
    final PaymentCardModel? chosenPaymentCard = dummyPaymentCards.isNotEmpty
        ? dummyPaymentCards.first
        : null;
    emit(
      CheckoutLoaded(
        checkoutItems: checkoutItems,
        totalAmount: subtotal + 10,
        numOfProducts: numOfProducts,
        chosenPaymentCard: chosenPaymentCard,
      ),
    );
  }

  void changePaymentMethod(PaymentCardModel card) {
    if (state is CheckoutLoaded) {
      final currentState = state as CheckoutLoaded;
      emit(
        CheckoutLoaded(
          checkoutItems: currentState.checkoutItems,
          totalAmount: currentState.totalAmount,
          numOfProducts: currentState.numOfProducts,
          chosenPaymentCard: card,
        ),
      );
    }
  }
}
