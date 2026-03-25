import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/cart_service.dart';

class ProductDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Column(
        children: [
          Image.asset(product.image),
          Text(product.name),
          Text('Rs. ${product.price}'),
          ElevatedButton(
            onPressed: () {
              CartService.addToCart(product);
            },
            child: Text('Add to Cart'),
          )
        ],
      ),
    );
  }
}
