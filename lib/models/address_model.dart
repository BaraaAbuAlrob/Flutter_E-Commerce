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
}

List<AddressModel> dummyAddresses = [
  const AddressModel(
    id: '1',
    city: 'Los Angeles',
    country: 'United States',
    street: '5482 Adobe Falls Rd #15San Diego, California(CA), 92120',
    title: 'House',
    pinColor: Color(0xFF00D2B4),
  ),
  const AddressModel(
    id: '2',
    city: 'San Francisco',
    country: 'United States',
    street: '450 Townsend St, San Francisco, California(CA), 94107',
    title: 'San Francisco',
    pinColor: Color(0xFF7E57C2),
  ),
  const AddressModel(
    id: '3',
    city: 'New York',
    country: 'United States',
    street: '350 5th Ave, New York, NY 10118',
    title: 'New York',
    pinColor: Color(0xFFFF5252),
  ),
  const AddressModel(
    id: '4',
    city: 'San Diego',
    country: 'United States',
    street: '5482 Adobe Falls Rd #15San Diego, California(CA), 92120',
    title: 'House',
    pinColor: Color(0xFFFF7043),
  ),
];
