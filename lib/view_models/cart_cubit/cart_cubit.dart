import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  void getCartItems() {
    emit(CartLoaded(List.from(dummyCart)));
  }

  void incrementCounter(String id) {
    final index = dummyCart.indexWhere((item) => item.id == id);
    if (index != -1) {
      dummyCart[index] = dummyCart[index].copyWith(
        quantity: dummyCart[index].quantity + 1,
      );
      emit(CartLoaded(List.from(dummyCart)));
    }
  }

  void decrementCounter(String id) {
    final index = dummyCart.indexWhere((item) => item.id == id);
    if (index != -1 && dummyCart[index].quantity > 1) {
      dummyCart[index] = dummyCart[index].copyWith(
        quantity: dummyCart[index].quantity - 1,
      );
      emit(CartLoaded(List.from(dummyCart)));
    }
  }
}