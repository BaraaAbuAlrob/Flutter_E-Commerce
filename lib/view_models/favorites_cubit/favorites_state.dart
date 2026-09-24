part of 'favorites_cubit.dart';

sealed class FavoritesState {
  const FavoritesState();
}

final class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

final class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

final class FavoritesLoaded extends FavoritesState {
  final List<ProductItemModel> favorites;
  final Set<String> favoriteProductIds;

  const FavoritesLoaded({
    required this.favorites,
    required this.favoriteProductIds,
  });
}

final class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);
}
