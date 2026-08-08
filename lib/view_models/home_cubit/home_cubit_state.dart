part of 'home_cubit.dart';

sealed class HomeCubitState {}

final class HomeInitial extends HomeCubitState {}

final class HomeLoading extends HomeCubitState {}

final class HomeLoaded extends HomeCubitState {
  final List<HomeCarouselItemModel> carouselItems;
  final List<ProductItemModel> products;

  HomeLoaded({required this.carouselItems, required this.products});
}

final class HomeError extends HomeCubitState {
  final String message;

  HomeError({required this.message});
}
