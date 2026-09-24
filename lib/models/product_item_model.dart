// ignore: constant_identifier_names
enum ProductSize { ns, S, M, L, XL }

enum ProductColor { nc, black, white, red, blue, green, yellow }

class ProductItemModel {
  final String id;
  final String name;
  final String imgUrl;
  final String description;
  final double price;
  final bool isFavorite;
  final String category;
  final String averageRate;
  final ProductColor color;
  final ProductSize size;

  ProductItemModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    this.description = '',
    required this.price,
    this.isFavorite = false,
    this.category = 'Others',
    this.averageRate = '0.0',
    this.color = ProductColor.nc,
    this.size = ProductSize.ns,
  });

  ProductItemModel copyWith({
    String? id,
    String? name,
    String? imgUrl,
    String? description,
    double? price,
    bool? isFavorite,
    String? category,
    String? averageRate,
    ProductColor? color,
    ProductSize? size,
  }) {
    return ProductItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imgUrl: imgUrl ?? this.imgUrl,
      description: description ?? this.description,
      price: price ?? this.price,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
      averageRate: averageRate ?? this.averageRate,
      color: color ?? this.color,
      size: size ?? this.size,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imgUrl': imgUrl,
      'description': description,
      'price': price,
      'isFavorite': isFavorite,
      'category': category,
      'averageRate': averageRate,
      'color': color.name,
      'size': size.name,
    };
  }

  factory ProductItemModel.fromMap(Map<String, dynamic> data, String documentId) {
    String parsedImgUrl = '';
    if (data['imgUrl'] != null && data['imgUrl'].toString().isNotEmpty) {
      parsedImgUrl = data['imgUrl'].toString();
    } else if (data['images'] is List && (data['images'] as List).isNotEmpty) {
      parsedImgUrl = (data['images'] as List).first.toString();
    } else if (data['image'] != null) {
      parsedImgUrl = data['image'].toString();
    }

    ProductSize parsedSize = ProductSize.ns;
    if (data['size'] != null) {
      final sizeStr = data['size'].toString();
      parsedSize = ProductSize.values.firstWhere(
        (s) => s.name.toLowerCase() == sizeStr.toLowerCase(),
        orElse: () => ProductSize.ns,
      );
    } else if (data['sizes'] is List && (data['sizes'] as List).isNotEmpty) {
      final firstSize = (data['sizes'] as List).first.toString();
      parsedSize = ProductSize.values.firstWhere(
        (s) => s.name.toLowerCase() == firstSize.toLowerCase(),
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

    return ProductItemModel(
      id: documentId.isNotEmpty ? documentId : (data['id']?.toString() ?? ''),
      name: data['name']?.toString() ?? '',
      imgUrl: parsedImgUrl,
      description: data['description']?.toString() ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      isFavorite: data['isFavorite'] == true,
      category: data['category']?.toString() ?? 'Others',
      averageRate: (data['averageRate'] ?? data['rating'])?.toString() ?? '0.0',
      color: parsedColor,
      size: parsedSize,
    );
  }
}
