import 'package:flutter/material.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: const Center(
        child: Text('Simple classic products screen'),
      ),
    );
  }
}
