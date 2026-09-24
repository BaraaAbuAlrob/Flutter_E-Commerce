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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product': product.toMap(),
      'size': size.name,
      'color': color.name,
      'quantity': quantity,
      'isSelected': isSelected,
    };
  }

  factory AddToCartModel.fromMap(Map<String, dynamic> data, String documentId) {
    ProductSize parsedSize = ProductSize.ns;
    if (data['size'] != null) {
      final sizeStr = data['size'].toString();
      parsedSize = ProductSize.values.firstWhere(
        (s) => s.name.toLowerCase() == sizeStr.toLowerCase(),
        orElse: () => ProductSize.ns,
      );
    }

    ProductColor parsedColor = ProductColor.nc;
    if (data['color'] != null) {
      final colorStr = data['color'].toString();
      parsedColor = ProductColor.values.firstWhere(
        (c) => c.name.toLowerCase() == colorStr.toLowerCase(),
        orElse: () => ProductColor.nc,
      );
    }

    final productData = data['product'] is Map<String, dynamic>
        ? data['product'] as Map<String, dynamic>
        : (data['product'] is Map
            ? Map<String, dynamic>.from(data['product'] as Map)
            : <String, dynamic>{});

    final productId = productData['id']?.toString() ??
        data['productId']?.toString() ??
        '';

    return AddToCartModel(
      id: documentId.isNotEmpty ? documentId : (data['id']?.toString() ?? ''),
      product: ProductItemModel.fromMap(productData, productId),
      size: parsedSize,
      color: parsedColor,
      quantity: (data['quantity'] as num?)?.toInt() ?? 1,
      isSelected: data['isSelected'] == true,
    );
  }
}