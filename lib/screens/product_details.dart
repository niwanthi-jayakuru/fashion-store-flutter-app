import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product =
        ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(title: Text(product["name"])),
      body: Column(
        children: [
          SizedBox(height: 20),

          Icon(Icons.image, size: 150),

          Text(product["name"], style: TextStyle(fontSize: 22)),
          Text("\$${product["price"]}"),

          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
            child: Text("Add to Cart"),
          )
        ],
      ),
    );
  }
}