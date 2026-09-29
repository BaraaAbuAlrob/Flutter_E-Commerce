import 'package:flutter_ecommerce_app/models/address_model.dart';
import 'package:flutter_ecommerce_app/models/category_model.dart';
import 'package:flutter_ecommerce_app/models/home_carousel_item_model.dart';
import 'package:flutter_ecommerce_app/models/payment_card_model.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeCacheData {
  final List<ProductItemModel> products;
  final List<CategoryModel> categories;
  final List<HomeCarouselItemModel> carouselItems;

  const HomeCacheData({
    required this.products,
    required this.categories,
    required this.carouselItems,
  });
}

class LocalStorageService {
  LocalStorageService._();
  static final LocalStorageService instance = LocalStorageService._();

  static const String cardsBoxName = 'cardsBox';
  static const String addressesBoxName = 'addressesBox';
  static const String homeCacheBoxName = 'homeCacheBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(cardsBoxName);
    await Hive.openBox<Map>(addressesBoxName);
    await Hive.openBox<dynamic>(homeCacheBoxName);
  }

  Box<Map> get cardsBox => Hive.box<Map>(cardsBoxName);
  Box<Map> get addressesBox => Hive.box<Map>(addressesBoxName);
  Box<dynamic> get homeCacheBox => Hive.box<dynamic>(homeCacheBoxName);

  // --- Home Data Cache ---
  HomeCacheData? getHomeData() {
    try {
      final box = homeCacheBox;
      final rawProducts = box.get('products');
      final rawCategories = box.get('categories');
      final rawCarousel = box.get('carousel');

      List<ProductItemModel> products = [];
      if (rawProducts is List) {
        products = rawProducts
            .whereType<Map>()
            .map((m) => ProductItemModel.fromMap(
                Map<String, dynamic>.from(m), m['id']?.toString() ?? ''))
            .toList();
      }

      List<CategoryModel> categories = [];
      if (rawCategories is List) {
        categories = rawCategories
            .whereType<Map>()
            .map((m) => CategoryModel.fromMap(
                Map<String, dynamic>.from(m), m['id']?.toString() ?? ''))
            .toList();
      }

      List<HomeCarouselItemModel> carouselItems = [];
      if (rawCarousel is List) {
        carouselItems = rawCarousel
            .whereType<Map>()
            .map((m) => HomeCarouselItemModel.fromMap(
                Map<String, dynamic>.from(m), m['id']?.toString() ?? ''))
            .toList();
      }

      if (products.isEmpty && categories.isEmpty && carouselItems.isEmpty) {
        return null;
      }

      return HomeCacheData(
        products: products,
        categories: categories,
        carouselItems: carouselItems,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveHomeData({
    required List<ProductItemModel> products,
    required List<CategoryModel> categories,
    required List<HomeCarouselItemModel> carouselItems,
  }) async {
    try {
      final box = homeCacheBox;
      await box.put(
        'products',
        products.map((p) => p.toMap()).toList(),
      );
      await box.put(
        'categories',
        categories.map((c) => c.toMap()).toList(),
      );
      await box.put(
        'carousel',
        carouselItems.map((c) => c.toMap()).toList(),
      );
    } catch (_) {}
  }

  // --- Payment Cards ---
  List<PaymentCardModel> getCards() {
    try {
      final box = cardsBox;
      return box.values
          .map((map) => PaymentCardModel.fromMap(map))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveCard(PaymentCardModel card) async {
    final box = cardsBox;
    await box.put(card.id, card.toMap());
  }

  Future<void> deleteCard(String cardId) async {
    final box = cardsBox;
    await box.delete(cardId);
  }

  // --- Addresses ---
  List<AddressModel> getAddresses() {
    try {
      final box = addressesBox;
      return box.values
          .map((map) => AddressModel.fromMap(map))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveAddress(AddressModel address) async {
    final box = addressesBox;
    await box.put(address.id, address.toMap());
  }

  Future<void> deleteAddress(String addressId) async {
    final box = addressesBox;
    await box.delete(addressId);
  }
}
