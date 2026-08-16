import 'package:flutter_ecommerce_app/models/product_item_model.dart';

class AddToCartModel {
  final String id;
  final ProductItemModel product;
  final ProductSize size;
  final ProductColor color;
  final int quantity;
  final bool isSelected;

  AddToCartModel({
    required this.id,
    required this.product,
    required this.size,
    required this.color,
    required this.quantity,
    this.isSelected = false,
  });

  double get totalPrice => product.price * quantity;

  AddToCartModel copyWith({
    String? id,
    ProductItemModel? product,
    ProductSize? size,
    ProductColor? color,
    int? quantity,
    bool? isSelected,
  }) {
    return AddToCartModel(
      id: id ?? this.id,
      product: product ?? this.product,
      size: size ?? this.size,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

List<AddToCartModel> dummyCart = [];