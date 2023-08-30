import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../model/cart_item.dart';
import '../utils/theme.dart';

class CartTile extends StatelessWidget {
  final CartItem item;

  const CartTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                height: 85,
                width: 85,
                decoration: BoxDecoration(
                  color: kcontentColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  item.product.image,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.product.category,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "\$${item.product.price}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Ionicons.trash_outline,
                  color: Colors.red,
                  size: 20,
                ),
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: kcontentColor,
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Expanded(
                  child: Text(
                    item.quantity.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
