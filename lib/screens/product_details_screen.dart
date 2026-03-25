import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[200],
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.image_not_supported)),
              ),
            ),
            const SizedBox(height: 16),
            Text(product.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Category: ${product.category}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text('Price: \$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text('Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(
                product.description.isNotEmpty
                    ? product.description
                    : 'No description available',
                style: const TextStyle(fontSize: 14)),
            const Spacer(),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Added ${product.name} to cart')));
                  },
                  child: const Text('Add to Cart'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
