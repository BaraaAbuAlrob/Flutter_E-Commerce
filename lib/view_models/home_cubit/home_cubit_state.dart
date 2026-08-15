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

  const HomeLoaded({required this.carouselItems, required this.products});
}

final class HomeError extends HomeCubitState {
  final String message;

  const HomeError({required this.message});
}
