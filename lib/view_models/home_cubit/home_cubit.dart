import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/category_model.dart';
import 'package:flutter_ecommerce_app/models/home_carousel_item_model.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/secrvices/firestore_services.dart';
import 'package:flutter_ecommerce_app/secrvices/local_storage_service.dart';

part 'home_cubit_state.dart';

class HomeCubit extends Cubit<HomeCubitState> {
  final FirestoreServices _firestoreServices = FirestoreServices.instance;
  final LocalStorageService _localStorageService = LocalStorageService.instance;

  HomeCubit() : super(HomeCubit._getInitialState());

  static HomeCubitState _getInitialState() {
    try {
      final cached = LocalStorageService.instance.getHomeData();
      if (cached != null &&
          (cached.products.isNotEmpty || cached.categories.isNotEmpty)) {
        return HomeLoaded(
          carouselItems: cached.carouselItems,
          products: cached.products,
          categories: cached.categories,
        );
      }
    } catch (_) {}
    return const HomeInitial();
  }

  Future<void> getHomeData() async {
    // Only emit loading state if there is no loaded cache already displayed
    if (state is! HomeLoaded) {
      emit(const HomeLoading());
    }

    try {
      // 1. Fetch Products from Firestore
      final products = await _firestoreServices.getCollection<ProductItemModel>(
        path: 'products',
        builder: (data, documentId) =>
            ProductItemModel.fromMap(data, documentId),
      );

      // 2. Fetch Categories from Firestore
      final categories = await _firestoreServices.getCollection<CategoryModel>(
        path: 'categories',
        builder: (data, documentId) => CategoryModel.fromMap(data, documentId),
      );

      // 3. Fetch Carousel Items or dynamically build from products if empty
      List<HomeCarouselItemModel> carouselItems = [];
      try {
        carouselItems =
            await _firestoreServices.getCollection<HomeCarouselItemModel>(
          path: 'carousel',
          builder: (data, documentId) =>
              HomeCarouselItemModel.fromMap(data, documentId),
        );
      } catch (_) {
        carouselItems = [];
      }

      if (carouselItems.isEmpty && products.isNotEmpty) {
        carouselItems = products
            .where((p) => p.imgUrl.isNotEmpty)
            .take(4)
            .map((p) => HomeCarouselItemModel(id: p.id, imgUrl: p.imgUrl))
            .toList();
      }

      // Persist to local cache for instant zero-delay loading on next start
      _localStorageService.saveHomeData(
        products: products,
        categories: categories,
        carouselItems: carouselItems,
      );

      emit(
        HomeLoaded(
          carouselItems: carouselItems,
          products: products,
          categories: categories,
        ),
      );
    } catch (e) {
      // If we already have cached data on screen, keep it
      if (state is! HomeLoaded) {
        emit(HomeError(message: 'Failed to fetch home data: ${e.toString()}'));
      }
    }
  }
}
