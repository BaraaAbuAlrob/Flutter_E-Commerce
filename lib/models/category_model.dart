import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';

class CategoryModel {
  final String id;
  final String name;
  final int productsCount;
  final Color bgColor;
  final Color textColor;
  final String imagePath;

  CategoryModel({
    required this.id,
    required this.name,
    required this.productsCount,
    this.bgColor = AppColors.primary,
    this.textColor = AppColors.white,
    this.imagePath =
        'https://img.pixelvault.dev/playground/tmp_4k77xiu8c4je.png',
  });
}

List<CategoryModel> dummyCategories = [
  CategoryModel(
    id: '1',
    name: 'New Arrivals',
    productsCount: 208,
    bgColor: AppColors.blue,
    textColor: AppColors.white,
    imagePath: 'assets/images/category_images/new_arrival.png',
  ),
  CategoryModel(
    id: '2',
    name: 'Clothes',
    productsCount: 358,
    bgColor: AppColors.green,
    textColor: AppColors.white,
    imagePath: 'assets/images/category_images/clothes.png',
  ),
  CategoryModel(
    id: '3',
    name: 'Bags',
    productsCount: 160,
    bgColor: AppColors.black,
    textColor: AppColors.white,
    imagePath: 'assets/images/category_images/school_bag.png',
  ),
  CategoryModel(
    id: '4',
    name: 'Shoes',
    productsCount: 230,
    bgColor: AppColors.white,
    textColor: AppColors.black,
    imagePath: 'assets/images/category_images/shoes.png',
  ),
  CategoryModel(
    id: '5',
    name: 'Electronics',
    productsCount: 101,
    bgColor: AppColors.primary,
    textColor: AppColors.black,
    imagePath: 'assets/images/category_images/electronics.png',
  ),
];
