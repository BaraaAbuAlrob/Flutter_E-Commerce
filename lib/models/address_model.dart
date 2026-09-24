import 'package:flutter/material.dart';

class AddressModel {
  final String id;
  final String city;
  final String country;
  final String? street;
  final String? title;
  final Color? pinColor;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.city,
    required this.country,
    this.street,
    this.title,
    this.pinColor,
    this.isDefault = false,
  });

  String get displayTitle => title != null && title!.isNotEmpty ? title! : city;

  String get subtitle => '$city, $country';

  String get fullAddress =>
      (street != null && street!.isNotEmpty) ? street! : '$city, $country';

  AddressModel copyWith({
    String? id,
    String? city,
    String? country,
    String? street,
    String? title,
    Color? pinColor,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      city: city ?? this.city,
      country: country ?? this.country,
      street: street ?? this.street,
      title: title ?? this.title,
      pinColor: pinColor ?? this.pinColor,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'city': city,
      'country': country,
      'street': street,
      'title': title,
      'pinColor': pinColor?.toARGB32(),
      'isDefault': isDefault,
    };
  }

  factory AddressModel.fromMap(Map<dynamic, dynamic> map) {
    return AddressModel(
      id: map['id']?.toString() ?? '',
      city: map['city']?.toString() ?? '',
      country: map['country']?.toString() ?? '',
      street: map['street']?.toString(),
      title: map['title']?.toString(),
      pinColor: map['pinColor'] != null
          ? Color(map['pinColor'] as int)
          : null,
      isDefault: map['isDefault'] == true,
    );
  }
}
