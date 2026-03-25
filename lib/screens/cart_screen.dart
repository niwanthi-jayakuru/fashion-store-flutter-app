import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: Column(
        children: [
          ListTile(
            title: Text("T-Shirt"),
            subtitle: Text("\$20"),
          ),

          Spacer(),

          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/checkout');
            },
            child: Text("Checkout"),
          ),
        ],
      ),
    );
  }
}