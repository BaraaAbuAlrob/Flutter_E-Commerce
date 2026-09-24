part of 'home_cubit.dart';

sealed class HomeCubitState {
  const HomeCubitState();
}

final class HomeInitial extends HomeCubitState {
  const HomeInitial();
}

final class HomeLoading extends HomeCubitState {
  const HomeLoading();
}

final class HomeLoaded extends HomeCubitState {
  final List<HomeCarouselItemModel> carouselItems;
  final List<ProductItemModel> products;
  final List<CategoryModel> categories;

  const HomeLoaded({
    required this.carouselItems,
    required this.products,
    this.categories = const [],
  });
}

final class HomeError extends HomeCubitState {
  final String message;

  const HomeError({required this.message});
}
