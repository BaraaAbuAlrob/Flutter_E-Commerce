import 'package:flutter_ecommerce_app/models/product_item_model.dart';

class AddToCartModel {
  final String productId;
  final ProductSize size;
  final ProductColor color;
  final int quantity;

  AddToCartModel({
    required this.productId,
    required this.size,
    required this.color,
    required this.quantity,
  });

  AddToCartModel copyWith({
    String? productId,
    ProductSize? size,
    ProductColor? color,
    int? quantity,
  }) {
    return AddToCartModel(
      productId: productId ?? this.productId,
      size: size ?? this.size,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
    );
  }
}

List<AddToCartModel> dummyCart = [];