import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models/favorites_cubit/favorites_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/empty_state_widget.dart';
import 'package:flutter_ecommerce_app/views/widgets/product_item.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        if (state is FavoritesLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (state is FavoritesError) {
          return Center(child: Text(state.message));
        }

        if (state is FavoritesLoaded) {
          final favorites = state.favorites;
          if (favorites.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.favorite_border_rounded,
              title: 'No Favorites Yet!',
              subtitle: 'Items marked as favorite will appear here in real-time.',
            );
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: favorites.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  mainAxisExtent: 240.0,
                ),
                itemBuilder: (context, index) {
                  final product = favorites[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamed(
                        AppRoutes.productDetailsPage,
                        arguments: product.id,
                      );
                    },
                    child: ProductItem(productItem: product),
                  );
                },
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
