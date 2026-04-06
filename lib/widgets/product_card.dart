import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_image.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: SizedBox(
        width: 55,
        height: 55,
        child: ProductImage(product: product),
      ),
      title: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
      onTap: () =>
          Navigator.pushNamed(context, '/productDetails', arguments: product),
      trailing: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Added ${product.name} to cart')));
        },
      ),
    );
  }
}
