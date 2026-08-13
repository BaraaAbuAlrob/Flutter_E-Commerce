import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/models/category_model.dart';

class CategoriesTabView extends StatelessWidget {
  const CategoriesTabView({super.key});

  Widget categoryImg(CategoryModel category) =>
      Image.asset(category.imagePath, width: 100, height: 100);

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
    return ListView.builder(
      itemCount: dummyCategories.length,
      itemBuilder: (context, index) {
        final category = dummyCategories[index];
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
  }
}
