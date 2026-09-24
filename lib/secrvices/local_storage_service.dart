import 'package:flutter_ecommerce_app/models/address_model.dart';
import 'package:flutter_ecommerce_app/models/payment_card_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  LocalStorageService._();
  static final LocalStorageService instance = LocalStorageService._();

  static const String cardsBoxName = 'cardsBox';
  static const String addressesBoxName = 'addressesBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(cardsBoxName);
    await Hive.openBox<Map>(addressesBoxName);
  }

  Box<Map> get cardsBox => Hive.box<Map>(cardsBoxName);
  Box<Map> get addressesBox => Hive.box<Map>(addressesBoxName);

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
