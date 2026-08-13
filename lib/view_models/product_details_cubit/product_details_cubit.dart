import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  void getProductDetails({required String productId}) async {
    final ProductItemModel product = dummyProducts.firstWhere(
      (item) => item.id == productId,
    );
    emit(ProductDetailsLoading());
    try {
      await Future.delayed(
        Duration(seconds: 1),
        () => emit(ProductDetailsLoaded(product: product)),
      );
    } catch (e) {
      emit(ProductDetailsError(message: e.toString()));
    }
  }

  void incrementCounter(String productId) {
    if (state is ProductDetailsLoaded || state is QuantityCounterLoaded) {
      final selectedIndex = dummyProducts.indexWhere(
        (item) => item.id == productId,
      );
      if (selectedIndex != -1) {
        dummyProducts[selectedIndex] = dummyProducts[selectedIndex].copyWith(
          quantity: dummyProducts[selectedIndex].quantity + 1,
        );
        emit(QuantityCounterLoaded(value: dummyProducts[selectedIndex].quantity));
      }
    }
  }

  void decrementCounter(String productId) {
    if (state is ProductDetailsLoaded || state is QuantityCounterLoaded) {
      final selectedIndex = dummyProducts.indexWhere(
        (item) => item.id == productId,
      );
      if (selectedIndex != -1 && dummyProducts[selectedIndex].quantity > 1) {
        dummyProducts[selectedIndex] = dummyProducts[selectedIndex].copyWith(
          quantity: dummyProducts[selectedIndex].quantity - 1,
        );
        emit(QuantityCounterLoaded(value: dummyProducts[selectedIndex].quantity));
      }
    }
  }
}
