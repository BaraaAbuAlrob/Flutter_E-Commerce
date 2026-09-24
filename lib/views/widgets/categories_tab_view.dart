import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/category_model.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/view_models/home_cubit/home_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/empty_state_widget.dart';

class CategoriesTabView extends StatelessWidget {
  const CategoriesTabView({super.key});

  Widget categoryImg(CategoryModel category) {
    if (category.imagePath.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: category.imagePath,
        width: 100,
        height: 100,
        fit: BoxFit.contain,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.category_outlined,
          size: 60,
          color: AppColors.white,
        ),
      );
    } else if (category.imagePath.isNotEmpty) {
      return Image.asset(
        category.imagePath,
        width: 100,
        height: 100,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.category_outlined,
          size: 60,
          color: AppColors.white,
        ),
      );
    }
    return const Icon(
      Icons.category_outlined,
      size: 60,
      color: AppColors.white,
    );
  }

  Widget categoryInfo(BuildContext context, CategoryModel category) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        category.name,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: category.textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      if (category.productsCount > 0)
        Text(
          '${category.productsCount} Products',
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: category.textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
    ],
  );

  Widget categoryForeground(
    BuildContext context,
    CategoryModel category,
    int index,
  ) {
    if (index % 2 == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [categoryImg(category), categoryInfo(context, category)],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [categoryInfo(context, category), categoryImg(category)],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeCubitState>(
      bloc: BlocProvider.of<HomeCubit>(context),
      buildWhen: (previous, current) =>
          current is HomeLoading ||
          current is HomeLoaded ||
          current is HomeError,
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is HomeLoaded) {
          final categories = state.categories;
          if (categories.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.category_outlined,
              title: 'No Categories Available',
              subtitle: 'Categories from the store will appear here.',
            );
          }

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InkWell(
                  onTap: () {},
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: category.bgColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 16.0,
                      ),
                      child: categoryForeground(context, category, index),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is HomeError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
