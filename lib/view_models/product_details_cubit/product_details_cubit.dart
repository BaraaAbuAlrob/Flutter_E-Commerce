import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {

  ProductSize selectedSize = ProductSize.ns;
  ProductColor selectedColor = ProductColor.nc;
  int quantity = 1;

  ProductDetailsCubit() : super(ProductDetailsInitial());

  void getProductDetails({required String productId}) async {
    final ProductItemModel product = dummyProducts.firstWhere(
      (item) => item.id == productId,
    );
    selectedSize = product.size;
    selectedColor = product.color;
    quantity = 1;
    emit(ProductDetailsLoading());
    try {
      await Future.delayed(
        const Duration(seconds: 1),
        () => emit(ProductDetailsLoaded(product: product)),
      );
    } catch (e) {
      emit(ProductDetailsError(message: e.toString()));
    }
  }

  void incrementCounter(String productId) {
    quantity++;
    emit(QuantityCounterLoaded(value: quantity));
  }

  void decrementCounter(String productId) {
    if (quantity > 1) {
      quantity--;
      emit(QuantityCounterLoaded(value: quantity));
    }
  }

  void selectSize(ProductSize size) {
    selectedSize = size;
    emit(SizeSelected(size: size));
  }

  void selectColor(ProductColor color) {
    selectedColor = color;
    emit(ColorSelected(color: color));
  }

  void addToCart(String productId) {
    emit(ProductAddingToCart());
    try {
      final product = dummyProducts.firstWhere((item) => item.id == productId);
      final existingIndex = dummyCart.indexWhere(
        (item) =>
            item.product.id == productId &&
            item.size == selectedSize &&
            item.color == selectedColor,
      );

      if (existingIndex != -1) {
        dummyCart[existingIndex] = dummyCart[existingIndex].copyWith(
          quantity: dummyCart[existingIndex].quantity + quantity,
        );
      } else {
        final cartItem = AddToCartModel(
          id: DateTime.now().toIso8601String(),
          product: product,
          size: selectedSize,
          color: selectedColor,
          quantity: quantity,
        );
        dummyCart.add(cartItem);
      }

      Future.delayed(
        const Duration(seconds: 1),
        () {
          emit(ProductAddedToCart(productId: productId));
        },
      );
    } catch (e) {
      emit(ProductDetailsError(message: e.toString()));
    }
  }
}
