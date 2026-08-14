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
    quantity = product.quantity;
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
    final selectedIndex = dummyProducts.indexWhere(
      (item) => item.id == productId,
    );
    if (selectedIndex != -1) {
      dummyProducts[selectedIndex] = dummyProducts[selectedIndex].copyWith(
        quantity: dummyProducts[selectedIndex].quantity + 1,
      );
      quantity = dummyProducts[selectedIndex].quantity;
      emit(QuantityCounterLoaded(value: quantity));
    }
  }

  void decrementCounter(String productId) {
    final selectedIndex = dummyProducts.indexWhere(
      (item) => item.id == productId,
    );
    if (selectedIndex != -1 && dummyProducts[selectedIndex].quantity > 1) {
      dummyProducts[selectedIndex] = dummyProducts[selectedIndex].copyWith(
        quantity: dummyProducts[selectedIndex].quantity - 1,
      );
      quantity = dummyProducts[selectedIndex].quantity;
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
      final cartItem = AddToCartModel(
        productId: productId,
        size: selectedSize,
        color: selectedColor,
        quantity: quantity,
      );
      dummyCart.add(cartItem);
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
