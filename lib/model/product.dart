import 'package:flutter/material.dart';

class Product {
  final int id;
  final String title;
  final String description;
  final String image;
  final double purchasePrice;
  final double sellingPrice;
  final int quantity;

  Product({
    required this.id,
    required this.title,
    required this.description,
    // required this.image,
    this.image = '"assets/wireless.png',
    required this.purchasePrice,
    required this.sellingPrice,
    required this.quantity,
  });
}
