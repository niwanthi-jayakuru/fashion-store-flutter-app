import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/details', arguments: product);
      },
      child: Card(
        child: Column(
          children: [
            Expanded(child: Image.asset(product.image)),
            Text(product.name),
            Text("Rs. ${product.price}"),
          ],
        ),
      ),
    );
  }
}
