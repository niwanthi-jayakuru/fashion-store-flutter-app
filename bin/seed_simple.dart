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
        {
          'name': 'Classic White T-Shirt',
          'price': 29.99,
          'category': 'Shirts',
          'image':
              'https://picsum.photos/seed/classic-white-tshirt/400/400',
        },
        {
          'name': 'Denim Jeans Blue',
          'price': 59.99,
          'category': 'Pants',
          'image': 'https://picsum.photos/seed/denim-jeans-blue/400/400',
        },
        {
          'name': 'Black Casual Hoodie',
          'price': 54.99,
          'category': 'Hoodies',
          'image': 'https://picsum.photos/seed/black-casual-hoodie/400/400',
        },
        {
          'name': 'Summer Floral Dress',
          'price': 49.99,
          'category': 'Dresses',
          'image': 'https://picsum.photos/seed/summer-floral-dress/400/400',
        },
        {
          'name': 'Leather Jacket',
          'price': 149.99,
          'category': 'Jackets',
          'image': 'https://picsum.photos/seed/leather-jacket/400/400',
        },
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
