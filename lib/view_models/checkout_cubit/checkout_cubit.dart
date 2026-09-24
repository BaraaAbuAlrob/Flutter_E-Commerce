import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/models/address_model.dart';
import 'package:flutter_ecommerce_app/models/payment_card_model.dart';
import 'package:flutter_ecommerce_app/secrvices/firestore_services.dart';
import 'package:flutter_ecommerce_app/secrvices/local_storage_service.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final FirestoreServices _firestoreServices = FirestoreServices.instance;
  final LocalStorageService _localStorageService = LocalStorageService.instance;

  CheckoutCubit() : super(CheckoutInitial());

  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  Future<void> getCartItems() async {
    emit(CheckoutLoading());
    final uid = _currentUserId;

    try {
      List<AddToCartModel> checkoutItems = [];
      if (uid != null) {
        checkoutItems = await _firestoreServices.getCollection<AddToCartModel>(
          path: 'users/$uid/cart',
          builder: (data, docId) => AddToCartModel.fromMap(data, docId),
        );
      }

      final subtotal = checkoutItems.fold<double>(
        0.0,
        (previousValue, element) =>
            previousValue + (element.product.price * element.quantity),
      );
      final numOfProducts = checkoutItems.fold<int>(
        0,
        (previousValue, element) => previousValue + element.quantity,
      );

      final savedCards = _localStorageService.getCards();
      final PaymentCardModel? chosenPaymentCard =
          savedCards.isNotEmpty ? savedCards.first : null;

      final savedAddresses = _localStorageService.getAddresses();
      final AddressModel? chosenAddress =
          savedAddresses.isNotEmpty ? savedAddresses.first : null;

      final double shipping = checkoutItems.isNotEmpty ? 10.0 : 0.0;
      final double totalAmount = subtotal + shipping;

      emit(
        CheckoutLoaded(
          checkoutItems: checkoutItems,
          totalAmount: totalAmount,
          numOfProducts: numOfProducts,
          chosenPaymentCard: chosenPaymentCard,
          chosenAddress: chosenAddress,
        ),
      );
    } catch (e) {
      emit(CheckoutError(message: 'Failed to load checkout details: $e'));
    }
  }

  void changePaymentMethod(PaymentCardModel card) {
    if (state is CheckoutLoaded) {
      final currentState = state as CheckoutLoaded;
      emit(currentState.copyWith(chosenPaymentCard: card));
    }
  }

  void changeAddress(AddressModel address) {
    if (state is CheckoutLoaded) {
      final currentState = state as CheckoutLoaded;
      emit(currentState.copyWith(chosenAddress: address));
    }
  }

  Future<void> placeOrder() async {
    if (state is! CheckoutLoaded) return;
    final currentState = state as CheckoutLoaded;

    if (currentState.checkoutItems.isEmpty) {
      emit(CheckoutError(message: 'Your cart is empty'));
      return;
    }

    if (currentState.chosenAddress == null) {
      emit(CheckoutError(message: 'Please select a shipping address first'));
      return;
    }

    final uid = _currentUserId;
    if (uid == null) {
      emit(CheckoutError(message: 'User must be signed in to place an order'));
      return;
    }

    emit(CheckoutPlacingOrder());
    try {
      final orderId = 'ORD_${DateTime.now().millisecondsSinceEpoch}';

      // 1. Write order to Firestore 'orders' collection
      await _firestoreServices.setData(
        path: 'orders/$orderId',
        data: {
          'orderId': orderId,
          'userId': uid,
          'userEmail': FirebaseAuth.instance.currentUser?.email ?? '',
          'items': currentState.checkoutItems.map((e) => e.toMap()).toList(),
          'totalAmount': currentState.totalAmount,
          'numOfProducts': currentState.numOfProducts,
          'shippingAddress': currentState.chosenAddress?.toMap(),
          'paymentCard': currentState.chosenPaymentCard?.toMap(),
          'status': 'Placed',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );

      // 2. Clear user cart in Firestore
      await _firestoreServices.clearCollection(path: 'users/$uid/cart');

      emit(OrderPlacedSuccess(orderId: orderId));
    } catch (e) {
      emit(CheckoutError(message: 'Failed to place order: $e'));
      // Restore loaded state if failed
      emit(currentState);
    }
  }
}
