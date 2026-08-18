import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  void getCartItems() {
    final subtotal = dummyCart.fold<double>(
      0,
      (previousValue, item) => previousValue + item.totalPrice,
    );
    emit(CartLoaded(List.from(dummyCart), subtotal));
  }

  void deleteItem(String id) {
    dummyCart.removeWhere((item) => item.id == id);
    getCartItems();
  }

  void toggleItemSelection(String id) {
    final index = dummyCart.indexWhere((item) => item.id == id);
    if (index != -1) {
      dummyCart[index] = dummyCart[index].copyWith(
        isSelected: !dummyCart[index].isSelected,
      );
      getCartItems();
    }
  }

  void incrementCounter(String id) {
    final index = dummyCart.indexWhere((item) => item.id == id);
    if (index != -1) {
      dummyCart[index] = dummyCart[index].copyWith(
        quantity: dummyCart[index].quantity + 1,
      );
      getCartItems();
    }
  }

  void decrementCounter(String id) {
    final index = dummyCart.indexWhere((item) => item.id == id);
    if (index != -1) {
      if (dummyCart[index].quantity > 1) {
        dummyCart[index] = dummyCart[index].copyWith(
          quantity: dummyCart[index].quantity - 1,
        );
        getCartItems();
      }
    }
  }
}
