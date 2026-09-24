import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/secrvices/firestore_services.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final FirestoreServices _firestoreServices = FirestoreServices.instance;
  StreamSubscription<List<AddToCartModel>>? _subscription;

  CartCubit() : super(CartInitial());

  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  void getCartItems() {
    final uid = _currentUserId;
    if (uid == null) {
      emit(const CartLoaded([], 0.0));
      return;
    }

    emit(CartLoading());
    _subscription?.cancel();
    _subscription = _firestoreServices
        .collectionStream<AddToCartModel>(
          path: 'users/$uid/cart',
          builder: (data, documentId) =>
              AddToCartModel.fromMap(data, documentId),
        )
        .listen(
          (items) {
            final subtotal = items.fold<double>(
              0.0,
              (previousValue, item) => previousValue + item.totalPrice,
            );
            emit(CartLoaded(items, subtotal));
          },
          onError: (e) {
            emit(CartError(e.toString()));
          },
        );
  }

  Future<void> deleteItem(String id) async {
    final uid = _currentUserId;
    if (uid == null) return;
    try {
      await _firestoreServices.deleteData(path: 'users/$uid/cart/$id');
    } catch (e) {
      emit(CartError('Failed to remove item: $e'));
    }
  }

  Future<void> toggleItemSelection(String id) async {
    final uid = _currentUserId;
    if (uid == null) return;

    if (state is CartLoaded) {
      final items = (state as CartLoaded).cartItems;
      final index = items.indexWhere((item) => item.id == id);
      if (index != -1) {
        final updated = items[index].copyWith(
          isSelected: !items[index].isSelected,
        );
        try {
          await _firestoreServices.setData(
            path: 'users/$uid/cart/$id',
            data: updated.toMap(),
          );
        } catch (_) {}
      }
    }
  }

  Future<void> incrementCounter(String id) async {
    final uid = _currentUserId;
    if (uid == null) return;

    if (state is CartLoaded) {
      final items = (state as CartLoaded).cartItems;
      final index = items.indexWhere((item) => item.id == id);
      if (index != -1) {
        final updated = items[index].copyWith(
          quantity: items[index].quantity + 1,
        );
        try {
          await _firestoreServices.setData(
            path: 'users/$uid/cart/$id',
            data: updated.toMap(),
          );
        } catch (_) {}
      }
    }
  }

  Future<void> decrementCounter(String id) async {
    final uid = _currentUserId;
    if (uid == null) return;

    if (state is CartLoaded) {
      final items = (state as CartLoaded).cartItems;
      final index = items.indexWhere((item) => item.id == id);
      if (index != -1 && items[index].quantity > 1) {
        final updated = items[index].copyWith(
          quantity: items[index].quantity - 1,
        );
        try {
          await _firestoreServices.setData(
            path: 'users/$uid/cart/$id',
            data: updated.toMap(),
          );
        } catch (_) {}
      }
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
