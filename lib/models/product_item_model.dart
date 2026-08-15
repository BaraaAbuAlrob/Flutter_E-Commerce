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
    this.description =
        'write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products... write any description for all products...',
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
}

List<ProductItemModel> dummyProducts = [
  ProductItemModel(
    id: '1',
    name: 'T-shirt',
    imgUrl: 'https://pngimg.com/uploads/tshirt/tshirt_PNG5450.png',
    price: 10,
    category: 'Clothes',
    averageRate: '4.5',
  ),
  ProductItemModel(
    id: '2',
    name: 'Black Shoes',
    imgUrl:
        'https://pngimg.com/uploads/running_shoes/running_shoes_PNG5823.png',
    price: 20,
    category: 'Shoes',
    averageRate: '4.0',
  ),
  ProductItemModel(
    id: '3',
    name: 'Trousers',
    imgUrl: 'https://pngimg.com/uploads/jeans/jeans_PNG5775.png',
    price: 30,
    category: 'Clothes',
    averageRate: '4.2',
  ),
  ProductItemModel(
    id: '4',
    name: 'Pack of Tomatoes',
    imgUrl: 'https://pngimg.com/uploads/tomato/tomato_PNG12594.png',
    price: 10,
    category: 'Groceries',
    averageRate: '4.0',
  ),
  ProductItemModel(
    id: '5',
    name: 'Pack of Potatoes',
    imgUrl: 'https://pngimg.com/uploads/potato/potato_PNG7081.png',
    price: 10,
    category: 'Groceries',
    averageRate: '4.0',
  ),
  ProductItemModel(
    id: '6',
    name: 'Pack of Onions',
    imgUrl: 'https://pngimg.com/uploads/onion/onion_PNG3821.png',
    price: 10,
    category: 'Groceries',
    averageRate: '3.0',
  ),
  ProductItemModel(
    id: '7',
    name: 'Pack of Apples',
    imgUrl: 'https://pngimg.com/uploads/apple/apple_PNG12405.png',
    price: 10,
    category: 'Fruits',
    averageRate: '4.7',
  ),
  ProductItemModel(
    id: '8',
    name: 'Pack of Oranges',
    imgUrl: 'https://pngimg.com/uploads/orange/orange_PNG780.png',
    price: 10,
    category: 'Fruits',
    averageRate: '3.1',
  ),
  ProductItemModel(
    id: '9',
    name: 'Pack of Bananas',
    imgUrl: 'https://pngimg.com/uploads/banana/banana_PNG827.png',
    price: 10,
    category: 'Fruits',
    averageRate: '4.3',
  ),
  ProductItemModel(
    id: '10',
    name: 'Pack of Mangoes',
    imgUrl: 'https://pngimg.com/uploads/mango/mango_PNG9179.png',
    price: 10,
    category: 'Fruits',
    averageRate: '2.7',
  ),
  ProductItemModel(
    id: '11',
    name: 'Sweet Shirt',
    imgUrl: 'https://pngimg.com/uploads/hoodie/hoodie_PNG38.png',
    price: 15,
    category: 'Clothes',
    averageRate: '2.4',
  ),
];
