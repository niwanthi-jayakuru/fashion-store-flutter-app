import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/product.dart';

class ProductListScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Products")),
      body: FutureBuilder<List<Product>>(
        future: _firebaseService.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No products found"));
          }

          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Image.network(
                    product.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image),
                  ),
                  title: Text(product.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("\$${product.price.toStringAsFixed(2)}",
                          style: const TextStyle(color: Colors.pink)),
                      Text(product.category,
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/productDetails',
                      arguments: product,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
