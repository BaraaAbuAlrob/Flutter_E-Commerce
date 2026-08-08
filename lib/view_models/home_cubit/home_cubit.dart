import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/home_carousel_item_model.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';

part 'home_cubit_state.dart';

class HomeCubit extends Cubit<HomeCubitState> {
  HomeCubit() : super(HomeInitial());

  void getHomeData() async {
    emit(HomeLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(
        HomeLoaded(
          carouselItems: dummyHomeCarouselItems,
          products: dummyProducts,
        ),
      );
    } catch (e) {
      emit(HomeError(message: 'Some error occurred!'));
    }
  }
}
