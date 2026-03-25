import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

void main(List<String> args) async {
  try {
    print('🔥 Initializing Firebase...\n');
    
    // Initialize Firebase (will use emulator if FIRESTORE_EMULATOR_HOST is set)
    await Firebase.initializeApp();
    
    final db = FirebaseFirestore.instance;

    if (args.isEmpty) {
      print('Usage: dart run bin/seed_products_simple.dart seed\n');
      return;
    }

    if (args[0] == 'seed') {
      print('🌱 Seeding sample products...\n');
      
      final products = [
        {'name': 'Classic White T-Shirt', 'price': 29.99, 'category': 'Shirts'},
        {'name': 'Denim Jeans Blue', 'price': 59.99, 'category': 'Pants'},
        {'name': 'Black Casual Hoodie', 'price': 54.99, 'category': 'Hoodies'},
        {'name': 'Summer Floral Dress', 'price': 49.99, 'category': 'Dresses'},
        {'name': 'Leather Jacket', 'price': 149.99, 'category': 'Jackets'},
      ];

      for (var product in products) {
        await db.collection('products').add(product);
        print('✅ Added: ${product['name']}');
      }
      
      print('\n✅ Done! Seeded ${products.length} products\n');
    }
  } catch (e) {
    print('❌ Error: $e');
  }
}
