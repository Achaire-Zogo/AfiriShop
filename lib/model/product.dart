import 'package:flutter/material.dart';

class Product {
  final String title;
  final String description;
  final String image;
  final double price;
  final String category;

  Product({
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.category,
  });
}

final List<Product> products = [
  Product(
    title: "Wireless Headphones",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Donec massa sapien faucibus et molestie ac feugiat. In massa tempor nec feugiat nisl. Libero id faucibus nisl tincidunt.",
    image: "assets/wireless.png",
    price: 120,
   
    category: "Headphones",
  ),
  Product(
    title: "Woman Sweter",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Donec massa sapien faucibus et molestie ac feugiat. In massa tempor nec feugiat nisl. Libero id faucibus nisl tincidunt.",
    image: "assets/sweet.png",
    price: 120,
  
    category: "Woman Fashion",
  ),
  Product(
    title: "Smart Watch",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Donec massa sapien faucibus et molestie ac feugiat. In massa tempor nec feugiat nisl. Libero id faucibus nisl tincidunt.",
    image: "assets/miband.jpg",
    price: 55,
    
    category: "Watch",
  ),
];
