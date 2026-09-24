import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/secrvices/firestore_services.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FirestoreServices _firestoreServices = FirestoreServices.instance;
  StreamSubscription<List<ProductItemModel>>? _subscription;

  FavoritesCubit() : super(const FavoritesInitial());

  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  void getFavorites() {
    final uid = _currentUserId;
    if (uid == null) {
      emit(const FavoritesLoaded(favorites: [], favoriteProductIds: {}));
      return;
    }

    emit(const FavoritesLoading());
    _subscription?.cancel();
    _subscription = _firestoreServices
        .collectionStream<ProductItemModel>(
          path: 'users/$uid/favorites',
          builder: (data, documentId) =>
              ProductItemModel.fromMap(data, documentId),
        )
        .listen(
          (favorites) {
            final ids = favorites.map((e) => e.id).toSet();
            emit(FavoritesLoaded(
              favorites: favorites,
              favoriteProductIds: ids,
            ));
          },
          onError: (e) {
            emit(FavoritesError(e.toString()));
          },
        );
  }

  Future<void> toggleFavorite(ProductItemModel product) async {
    final uid = _currentUserId;
    if (uid == null) return;

    final currentState = state;
    bool isCurrentlyFav = false;
    if (currentState is FavoritesLoaded) {
      isCurrentlyFav = currentState.favoriteProductIds.contains(product.id);
    }

    try {
      final docPath = 'users/$uid/favorites/${product.id}';
      if (isCurrentlyFav) {
        await _firestoreServices.deleteData(path: docPath);
      } else {
        await _firestoreServices.setData(
          path: docPath,
          data: product.copyWith(isFavorite: true).toMap(),
        );
      }
    } catch (e) {
      // Error handling
    }
  }

  bool isFavorite(String productId) {
    if (state is FavoritesLoaded) {
      return (state as FavoritesLoaded).favoriteProductIds.contains(productId);
    }
    return false;
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
