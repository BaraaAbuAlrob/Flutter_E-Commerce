import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/view_models/product_details_cubit/product_details_cubit.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<ProductDetailsCubit>(context),
      builder: (BuildContext context, state) {
        if (state is ProductDetailsLoading) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (state is ProductDetailsLoaded) {
          return Scaffold(
            appBar: AppBar(
              title: Text(state.product.name),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border),
                ),
              ],
            ),
            body: Stack(
              children: [CachedNetworkImage(imageUrl: state.product.imgUrl)],
            ),
          );
        } else if (state is ProductDetailsError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text(state.message)),
          );
        } else {
          return Scaffold(body: Center(child: Text('Unknown state')));
        }
      },
    );
  }
}
