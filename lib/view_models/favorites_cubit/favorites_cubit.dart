import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/secrvices/firestore_services.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FirestoreServices _firestoreServices = FirestoreServices.instance;

  FavoritesCubit() : super(const FavoritesInitial());

  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  Future<void> getFavorites({bool isRefresh = false}) async {
    final uid = _currentUserId;
    if (uid == null) {
      emit(const FavoritesLoaded(favorites: [], favoriteProductIds: {}));
      return;
    }

    if (!isRefresh && state is! FavoritesLoaded) {
      emit(const FavoritesLoading());
    }

    try {
      final favorites = await _firestoreServices.getCollection<ProductItemModel>(
        path: 'users/$uid/favorites',
        builder: (data, documentId) =>
            ProductItemModel.fromMap(data, documentId),
      );

      final ids = favorites.map((e) => e.id).toSet();
      emit(FavoritesLoaded(
        favorites: favorites,
        favoriteProductIds: ids,
      ));
    } catch (e) {
      if (state is! FavoritesLoaded) {
        emit(FavoritesError(e.toString()));
      }
    }
  }

  Future<void> toggleFavorite(ProductItemModel product) async {
    final uid = _currentUserId;
    if (uid == null) return;

    final currentState = state;
    List<ProductItemModel> currentList = [];
    Set<String> currentIds = {};

    if (currentState is FavoritesLoaded) {
      currentList = List.from(currentState.favorites);
      currentIds = Set.from(currentState.favoriteProductIds);
    }

    final isCurrentlyFav = currentIds.contains(product.id);

    // Optimistic update
    if (isCurrentlyFav) {
      currentIds.remove(product.id);
      currentList.removeWhere((item) => item.id == product.id);
    } else {
      currentIds.add(product.id);
      currentList.add(product.copyWith(isFavorite: true));
    }

    emit(FavoritesLoaded(
      favorites: currentList,
      favoriteProductIds: currentIds,
    ));

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
      // Revert to previous state if Firestore operation failed
      if (currentState is FavoritesLoaded) {
        emit(currentState);
      }
    }
  }

  bool isFavorite(String productId) {
    if (state is FavoritesLoaded) {
      return (state as FavoritesLoaded).favoriteProductIds.contains(productId);
    }
    return false;
  }
}
