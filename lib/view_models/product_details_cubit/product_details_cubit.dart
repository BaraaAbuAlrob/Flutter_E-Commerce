import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/secrvices/firestore_services.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final FirestoreServices _firestoreServices = FirestoreServices.instance;

  ProductSize selectedSize = ProductSize.ns;
  ProductColor selectedColor = ProductColor.nc;
  int quantity = 1;
  ProductItemModel? currentProduct;

  ProductDetailsCubit() : super(const ProductDetailsInitial());

  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  Future<void> getProductDetails({required String productId}) async {
    emit(const ProductDetailsLoading());
    try {
      final ProductItemModel product =
          await _firestoreServices.getDocument<ProductItemModel>(
        path: 'products/$productId',
        builder: (data, documentId) =>
            ProductItemModel.fromMap(data, documentId),
      );

      currentProduct = product;
      selectedSize = product.size;
      selectedColor = product.color;
      quantity = 1;

      emit(ProductDetailsLoaded(product: product));
    } catch (e) {
      emit(ProductDetailsError(message: 'Failed to load product details: $e'));
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

  Future<void> addToCart(String productId) async {
    final uid = _currentUserId;
    if (uid == null) {
      emit(const ProductDetailsError(message: 'User must be signed in to add to cart'));
      return;
    }

    final product = currentProduct;
    if (product == null) {
      emit(const ProductDetailsError(message: 'Product not loaded'));
      return;
    }

    emit(const ProductAddingToCart());
    try {
      final cartDocId = '${productId}_${selectedSize.name}_${selectedColor.name}';
      final path = 'users/$uid/cart/$cartDocId';

      // Check if existing item in cart
      int finalQuantity = quantity;
      try {
        final existingItem = await _firestoreServices.getDocument<AddToCartModel>(
          path: path,
          builder: (data, docId) => AddToCartModel.fromMap(data, docId),
        );
        finalQuantity += existingItem.quantity;
      } catch (_) {
        // Not in cart yet
      }

      final cartItem = AddToCartModel(
        id: cartDocId,
        product: product,
        size: selectedSize,
        color: selectedColor,
        quantity: finalQuantity,
        isSelected: true,
      );

      await _firestoreServices.setData(
        path: path,
        data: cartItem.toMap(),
      );

      emit(ProductAddedToCart(productId: productId));
    } catch (e) {
      emit(ProductDetailsError(message: 'Failed to add to cart: $e'));
    }
  }
}
