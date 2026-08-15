part of 'product_details_cubit.dart';

sealed class ProductDetailsState {
  const ProductDetailsState();
}

final class ProductDetailsInitial extends ProductDetailsState {
  const ProductDetailsInitial();
}

final class ProductDetailsLoading extends ProductDetailsState {
  const ProductDetailsLoading();
}

final class ProductDetailsLoaded extends ProductDetailsState {
  final ProductItemModel product;

  const ProductDetailsLoaded({required this.product});
}

final class QuantityCounterLoaded extends ProductDetailsState {
  final int value;

  const QuantityCounterLoaded({required this.value});
}

final class SizeSelected extends ProductDetailsState {
  final ProductSize size;

  const SizeSelected({required this.size});
}

final class ColorSelected extends ProductDetailsState {
  final ProductColor color;

  const ColorSelected({required this.color});
}

final class ProductAddingToCart extends ProductDetailsState {
  const ProductAddingToCart();
}

final class ProductAddedToCart extends ProductDetailsState {
  final String productId;

  const ProductAddedToCart({required this.productId});
}

final class ProductDetailsError extends ProductDetailsState {
  final String message;

  const ProductDetailsError({required this.message});
}
