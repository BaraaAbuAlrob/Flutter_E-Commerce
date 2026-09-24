import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/view_models/favorites_cubit/favorites_cubit.dart';

class ProductItem extends StatelessWidget {
  final ProductItemModel productItem;

  const ProductItem({super.key, required this.productItem});

  @override
  Widget build(BuildContext context) {
    FavoritesCubit? favCubit;
    try {
      favCubit = BlocProvider.of<FavoritesCubit>(context, listen: false);
    } catch (_) {
      favCubit = null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 150.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: AppColors.grey100,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: productItem.imgUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: productItem.imgUrl,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.broken_image_outlined, color: AppColors.grey),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.image_not_supported_outlined, color: AppColors.grey),
                      ),
              ),
            ),
            Positioned(
              top: 6.0,
              right: 6.0,
              child: favCubit != null
                  ? BlocBuilder<FavoritesCubit, FavoritesState>(
                      bloc: favCubit,
                      builder: (context, state) {
                        final isFav = favCubit!.isFavorite(productItem.id);
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white.withValues(alpha: 0.85),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowSubtle,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            iconSize: 20,
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              favCubit?.toggleFavorite(productItem);
                            },
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? AppColors.red : AppColors.grey600,
                            ),
                          ),
                        );
                      },
                    )
                  : DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white.withValues(alpha: 0.85),
                      ),
                      child: IconButton(
                        iconSize: 20,
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(),
                        onPressed: null,
                        icon: const Icon(Icons.favorite_border, color: AppColors.grey600),
                      ),
                    ),
            ),
          ],
        ),
        const SizedBox(height: 6.0),
        Text(
          productItem.name,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.w600, fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          productItem.category,
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: AppColors.grey500, fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2.0),
        Text(
          '\$${productItem.price.toStringAsFixed(2)}',
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
      ],
    );
  }
}
