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
    this.productsCount = 0,
    this.bgColor = AppColors.primary,
    this.textColor = AppColors.white,
    this.imagePath = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'productsCount': productsCount,
      'bgColor': bgColor.toARGB32(),
      'textColor': textColor.toARGB32(),
      'imagePath': imagePath,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> data, String documentId) {
    String parsedImg = '';
    if (data['imagePath'] != null && data['imagePath'].toString().isNotEmpty) {
      parsedImg = data['imagePath'].toString();
    } else if (data['icon'] != null && data['icon'].toString().isNotEmpty) {
      parsedImg = data['icon'].toString();
    } else if (data['image'] != null && data['image'].toString().isNotEmpty) {
      parsedImg = data['image'].toString();
    } else if (data['imgUrl'] != null && data['imgUrl'].toString().isNotEmpty) {
      parsedImg = data['imgUrl'].toString();
    }

    Color parsedBg = AppColors.primary;
    if (data['bgColor'] is int) {
      parsedBg = Color(data['bgColor'] as int);
    }

    Color parsedText = AppColors.white;
    if (data['textColor'] is int) {
      parsedText = Color(data['textColor'] as int);
    }

    return CategoryModel(
      id: documentId.isNotEmpty ? documentId : (data['id']?.toString() ?? ''),
      name: data['name']?.toString() ?? '',
      productsCount: (data['productsCount'] as num?)?.toInt() ?? 0,
      bgColor: parsedBg,
      textColor: parsedText,
      imagePath: parsedImg,
    );
  }
}
