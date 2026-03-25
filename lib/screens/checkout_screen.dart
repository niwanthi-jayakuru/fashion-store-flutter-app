import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: "Address",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Order Placed")),
                );
              },
              child: Text("Place Order"),
            )
          ],
        ),
      ),
    );
  }
}