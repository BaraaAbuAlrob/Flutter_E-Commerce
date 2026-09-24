import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/category_model.dart';
import 'package:flutter_ecommerce_app/models/home_carousel_item_model.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/secrvices/firestore_services.dart';

part 'home_cubit_state.dart';

class HomeCubit extends Cubit<HomeCubitState> {
  final FirestoreServices _firestoreServices = FirestoreServices.instance;

  HomeCubit() : super(const HomeInitial());

  Future<void> getHomeData() async {
    emit(const HomeLoading());
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

      emit(
        HomeLoaded(
          carouselItems: carouselItems,
          products: products,
          categories: categories,
        ),
      );
    } catch (e) {
      emit(HomeError(message: 'Failed to fetch home data: ${e.toString()}'));
    }
  }
}
