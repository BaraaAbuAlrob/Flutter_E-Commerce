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
          return RefreshIndicator(
            onRefresh: () async {
              await context.read<FavoritesCubit>().getFavorites(isRefresh: true);
            },
            color: Theme.of(context).primaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        if (state is FavoritesLoaded) {
          final favorites = state.favorites;
          if (favorites.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<FavoritesCubit>().getFavorites(isRefresh: true);
              },
              color: Theme.of(context).primaryColor,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: const Center(
                        child: EmptyStateWidget(
                          icon: Icons.favorite_border_rounded,
                          title: 'No Favorites Yet!',
                          subtitle: 'Items marked as favorite will appear here.',
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await context.read<FavoritesCubit>().getFavorites(isRefresh: true);
              },
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
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
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
