import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/view_models/product_details_cubit/product_details_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/counter_widget.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productId;

  const ProductDetailsPage({super.key, required this.productId});

  Widget sizeList({
    required ProductSize size,
    required BuildContext context,
    required ProductDetailsState state,
  }) {
    final cubit = BlocProvider.of<ProductDetailsCubit>(context);
    bool isSelected = state is SizeSelected && state.size == size;
    try {
      if (state is ProductDetailsLoaded) {
        isSelected = cubit.selectedSize == size;
      }
    } catch (_) {}

    final primaryColor = AppColors.primary;

    if (size.name == 'ns') {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : AppColors.grey100,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? primaryColor : AppColors.grey300,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Icon(
            Icons.not_interested_rounded,
            size: 20,
            color: isSelected ? AppColors.white : AppColors.grey500,
          ),
        ),
      );
    } else {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : AppColors.grey100,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? primaryColor : AppColors.grey300,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            size.name,
            style: TextStyle(
              fontSize: isSelected ? 15 : 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? AppColors.white : AppColors.black87,
            ),
          ),
        ),
      );
    }
  }

  Widget colorList({
    required ProductColor color,
    required BuildContext context,
    required ProductDetailsState state,
  }) {
    final cubit = BlocProvider.of<ProductDetailsCubit>(context);
    bool isSelected = state is ColorSelected && state.color == color;
    try {
      if (state is ProductDetailsLoaded) {
        isSelected = cubit.selectedColor == color;
      }
    } catch (_) {}

    final primaryColor = AppColors.primary;

    if (color.name == 'nc') {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: 42,
        height: 42,
        padding: EdgeInsets.all(isSelected ? 8.0 : 0.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? primaryColor : AppColors.grey300,
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 3,
                    offset: const Offset(0, 0),
                  ),
                ]
              : null,
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? primaryColor.withValues(alpha: 0.15)
                : AppColors.grey100,
          ),
          child: Center(
            child: Icon(
              Icons.not_interested_rounded,
              size: isSelected ? 20 : 18,
              color: isSelected ? AppColors.white : AppColors.grey500,
            ),
          ),
        ),
      );
    } else {
      final actualColor =
          AppColors.getColorByName(color.name) ?? Colors.transparent;
      final bool isLightColor = color.name == 'white' || color.name == 'yellow';

      return AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: 42,
        height: 42,
        padding: EdgeInsets.all(isSelected ? 3.0 : 0.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? primaryColor
                : (color.name == 'white'
                      ? AppColors.grey300
                      : AppColors.transparent),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 0),
                  ),
                ]
              : null,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: actualColor,
            border: Border.all(
              color: color.name == 'white'
                  ? AppColors.grey300
                  : AppColors.black12,
              width: 1,
            ),
          ),
          child: isSelected
              ? Center(
                  child: Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: isLightColor ? AppColors.black87 : AppColors.white,
                  ),
                )
              : null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      bloc: BlocProvider.of<ProductDetailsCubit>(context),
      buildWhen: (previous, current) =>
          current is ProductDetailsLoading ||
          current is ProductDetailsLoaded ||
          current is ProductDetailsError,
      builder: (context, state) {
        if (state is ProductDetailsLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        } else if (state is ProductDetailsError) {
          return Scaffold(body: Center(child: Text(state.message)));
        } else if (state is ProductDetailsLoaded) {
          final product = state.product;
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: AppColors.transparent,
              elevation: 0,
              title: const Text('Product Details'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
              ],
            ),
            body: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: size.height * 0.52,
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.grey300),
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.1),
                        CachedNetworkImage(
                          imageUrl: product.imgUrl,
                          height: size.height * 0.4,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  top: size.height * 0.47,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        left: 36.0,
                        right: 36.0,
                        top: 36.0,
                        bottom: 100.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: AppColors.yellow,
                                        size: 25,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        product.averageRate.toString(),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              BlocBuilder<
                                ProductDetailsCubit,
                                ProductDetailsState
                              >(
                                bloc: BlocProvider.of<ProductDetailsCubit>(
                                  context,
                                ),
                                buildWhen: (previous, current) =>
                                    current is QuantityCounterLoaded ||
                                    current is ProductDetailsLoaded,
                                builder: (context, state) {
                                  if (state is QuantityCounterLoaded) {
                                    return CounterWidget(
                                      value: state.value,
                                      productId: product.id,
                                      cubit:
                                          BlocProvider.of<ProductDetailsCubit>(
                                            context,
                                          ),
                                    );
                                  } else if (state is ProductDetailsLoaded) {
                                    final cubit =
                                        BlocProvider.of<ProductDetailsCubit>(
                                          context,
                                        );
                                    return CounterWidget(
                                      value: cubit.quantity,
                                      productId: product.id,
                                      cubit: cubit,
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Size',
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                            bloc: BlocProvider.of<ProductDetailsCubit>(context),
                            buildWhen: (previous, current) =>
                                current is ProductDetailsLoaded ||
                                current is SizeSelected,
                            builder: (context, state) => Row(
                              children: ProductSize.values
                                  .map(
                                    (size) => Padding(
                                      padding: const EdgeInsets.only(
                                        top: 6.0,
                                        right: 8.0,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          BlocProvider.of<ProductDetailsCubit>(
                                            context,
                                          ).selectSize(size);
                                        },
                                        child: sizeList(
                                          size: size,
                                          context: context,
                                          state: state,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Color',
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child:
                                BlocBuilder<
                                  ProductDetailsCubit,
                                  ProductDetailsState
                                >(
                                  bloc: BlocProvider.of<ProductDetailsCubit>(
                                    context,
                                  ),
                                  buildWhen: (previous, current) =>
                                      current is ProductDetailsLoaded ||
                                      current is ColorSelected,
                                  builder: (context, state) => Row(
                                    children: ProductColor.values
                                        .map(
                                          (color) => Padding(
                                            padding: const EdgeInsets.only(
                                              top: 6.0,
                                              right: 8.0,
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                BlocProvider.of<
                                                      ProductDetailsCubit
                                                    >(context)
                                                    .selectColor(color);
                                              },
                                              child: colorList(
                                                color: color,
                                                context: context,
                                                state: state,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Description',
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            product.description,
                            style: Theme.of(context).textTheme.labelMedium!
                                .copyWith(color: AppColors.black45),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36.0,
                      vertical: 16.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(36.0),
                      ),
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowMedium,
                          blurRadius: 10,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: '\$',
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontSize: 24,
                                ),
                            children: [
                              TextSpan(
                                text: product.price.toString(),
                                style: Theme.of(context).textTheme.titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 36,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                          bloc: BlocProvider.of<ProductDetailsCubit>(context),
                          buildWhen: (previous, current) =>
                              current is ProductAddedToCart ||
                              current is ProductAddingToCart,
                          builder: (context, state) {
                            if (state is ProductAddingToCart) {
                              return ElevatedButton(
                                onPressed: null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 28,
                                    height: 28,
                                    child:
                                        const CircularProgressIndicator.adaptive(),
                                  ),
                                ),
                              );
                            } else if (state is ProductAddedToCart) {
                              return ElevatedButton(
                                onPressed: null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.white,
                                ),
                                child: const Text(
                                  'Added Successfully!',
                                  style: TextStyle(fontSize: 20),
                                ),
                              );
                            }
                            return ElevatedButton.icon(
                              onPressed: () =>
                                  BlocProvider.of<ProductDetailsCubit>(
                                    context,
                                  ).addToCart(product.id),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.white,
                              ),
                              label: const Text(
                                'Add to Cart',
                                style: TextStyle(fontSize: 20),
                              ),
                              icon: const Icon(Icons.shopping_bag_outlined),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text('Something went wrong!')),
          );
        }
      },
    );
  }
}
