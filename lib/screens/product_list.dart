import 'package:flutter/material.dart';

class ProductListScreen extends StatelessWidget {
  final List products = [
    {"name": "Shoes", "price": 80},
    {"name": "Bag", "price": 40},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Products")),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text(products[index]["name"]),
            subtitle: Text("\$${products[index]["price"]}"),
            onTap: () {
              Navigator.pushNamed(context, '/productDetails');
            },
          );
        },
      ),
    );
  }
}