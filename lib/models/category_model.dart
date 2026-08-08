import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';

class CategoryModel {
  final String id;
  final String name;
  final int productsCount;
  final Color bgColor;
  final Color textColor;
  final String imageUrl;

  CategoryModel({
    required this.id,
    required this.name,
    required this.productsCount,
    this.bgColor = AppColors.primary,
    this.textColor = AppColors.white,
    this.imageUrl =
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
    imageUrl: 'https://img.pixelvault.dev/playground/tmp_h8ydkxtu8imz.png',
  ),
  CategoryModel(
    id: '2',
    name: 'Clothes',
    productsCount: 358,
    bgColor: AppColors.green,
    textColor: AppColors.white,
    imageUrl: 'https://img.pixelvault.dev/playground/tmp_phj9wwkdx4hu.png',
  ),
  CategoryModel(
    id: '3',
    name: 'Bags',
    productsCount: 160,
    bgColor: AppColors.black,
    textColor: AppColors.white,
    imageUrl: 'https://img.pixelvault.dev/playground/tmp_czf3ess4b36b.png',
  ),
  CategoryModel(
    id: '4',
    name: 'Shoes',
    productsCount: 230,
    bgColor: AppColors.white,
    textColor: AppColors.black,
    imageUrl: 'https://img.pixelvault.dev/playground/tmp_xjj9ileicmav.png',
  ),
  CategoryModel(
    id: '5',
    name: 'Electronics',
    productsCount: 101,
    bgColor: AppColors.primary,
    textColor: AppColors.black,
    imageUrl: 'https://img.pixelvault.dev/playground/tmp_x2zysqvawp1b.png',
  ),
];
