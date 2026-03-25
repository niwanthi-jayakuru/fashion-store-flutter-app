import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

final List<Map<String, dynamic>> sampleProducts = [
  {
    'name': 'Classic White T-Shirt',
    'price': 29.99,
    'category': 'Shirts',
    'image':
        'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
    'description':
        'Comfortable classic white t-shirt perfect for everyday wear',
    'rating': 4.5,
    'stock': 50,
  },
  {
    'name': 'Denim Jeans Blue',
    'price': 59.99,
    'category': 'Pants',
    'image': 'https://images.unsplash.com/photo-1542272604-787c62d465d1?w=400',
    'description': 'Stylish blue denim jeans with a perfect fit',
    'rating': 4.8,
    'stock': 35,
  },
  {
    'name': 'Black Casual Hoodie',
    'price': 54.99,
    'category': 'Hoodies',
    'image': 'https://images.unsplash.com/photo-1556821840-a63b86e8e119?w=400',
    'description': 'Warm and cozy black hoodie for all seasons',
    'rating': 4.6,
    'stock': 40,
  },
  {
    'name': 'Summer Floral Dress',
    'price': 49.99,
    'category': 'Dresses',
    'image':
        'https://images.unsplash.com/photo-1595777712802-eebf6d2e6c7f?w=400',
    'description': 'Beautiful floral dress perfect for summer outings',
    'rating': 4.7,
    'stock': 25,
  },
  {
    'name': 'Leather Jacket',
    'price': 149.99,
    'category': 'Jackets',
    'image': 'https://images.unsplash.com/photo-1551028719-00167b16ebc5?w=400',
    'description': 'Premium leather jacket with classic style',
    'rating': 4.9,
    'stock': 15,
  },
  {
    'name': 'Striped Polo Shirt',
    'price': 39.99,
    'category': 'Shirts',
    'image':
        'https://images.unsplash.com/photo-1591028589139-5e89b2f6f90f?w=400',
    'description':
        'Elegant striped polo shirt for casual and semi-formal occasions',
    'rating': 4.4,
    'stock': 45,
  },
  {
    'name': 'Cargo Pants Khaki',
    'price': 64.99,
    'category': 'Pants',
    'image':
        'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=400',
    'description': 'Comfortable cargo pants with multiple pockets',
    'rating': 4.3,
    'stock': 30,
  },
  {
    'name': 'Athletic Sports Shorts',
    'price': 34.99,
    'category': 'Shorts',
    'image':
        'https://images.unsplash.com/photo-1506629082632-47a1e86cdf23?w=400',
    'description': 'Lightweight sports shorts for active lifestyle',
    'rating': 4.2,
    'stock': 60,
  },
  {
    'name': 'Vintage Sweater',
    'price': 44.99,
    'category': 'Sweaters',
    'image':
        'https://images.unsplash.com/photo-1578507065211-1c4e80f47b51?w=400',
    'description': 'Cozy vintage-style sweater in neutral colors',
    'rating': 4.6,
    'stock': 28,
  },
  {
    'name': 'Windbreaker Jacket',
    'price': 69.99,
    'category': 'Jackets',
    'image':
        'https://images.unsplash.com/photo-1583948915529-cd4628902246?w=400',
    'description': 'Lightweight windbreaker perfect for outdoor activities',
    'rating': 4.5,
    'stock': 22,
  },
];

Future<void> seedProducts(FirebaseFirestore db) async {
  try {
    print('🌱 Starting to seed products...\n');

    WriteBatch batch = db.batch();
    int count = 0;

    for (var product in sampleProducts) {
      DocumentReference docRef = db.collection('products').doc();
      batch.set(docRef, {
        ...product,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      count++;
      print('  ✓ Added: ${product['name']}');

      if (count % 500 == 0) {
        await batch.commit();
        batch = db.batch();
      }
    }

    if (count % 500 != 0) {
      await batch.commit();
    }

    print('\n✅ Successfully seeded $count products!\n');
  } catch (e) {
    print('❌ Error seeding products: $e');
    rethrow;
  }
}

Future<void> clearProducts(FirebaseFirestore db) async {
  try {
    print('🗑️  Clearing all products...\n');
    final snapshot = await db.collection('products').get();

    WriteBatch batch = db.batch();
    int count = 0;

    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
      count++;

      if (count % 500 == 0) {
        await batch.commit();
        batch = db.batch();
      }
    }

    if (count % 500 != 0) {
      await batch.commit();
    }

    print('✅ Successfully cleared $count products!\n');
  } catch (e) {
    print('❌ Error clearing products: $e');
    rethrow;
  }
}

void main(List<String> args) async {
  try {
    // Initialize Firebase
    print('🔥 Initializing Firebase...\n');
    await Firebase.initializeApp();

    // Connect to Firebase Emulator
    print('🌐 Connecting to Firestore Emulator at localhost:8080...\n');
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

    final db = FirebaseFirestore.instance;

    if (args.isEmpty) {
      print('Usage: dart run bin/seed_products.dart [seed|clear]\n');
      print('Commands:');
      print('  seed  - Add sample products to the database');
      print('  clear - Remove all products from the database\n');
      exit(0);
    }

    final command = args[0].toLowerCase();

    if (command == 'seed') {
      await seedProducts(db);
    } else if (command == 'clear') {
      print('⚠️  WARNING: This will delete all products!\n');
      print('Type "yes" to confirm: ');
      final input = stdin.readLineSync()?.toLowerCase() ?? '';
      if (input == 'yes') {
        await clearProducts(db);
      } else {
        print('Cancelled.\n');
      }
    } else {
      print('❌ Unknown command: $command\n');
      print('Use "seed" or "clear"\n');
      exit(1);
    }

    exit(0);
  } catch (e) {
    print('❌ Fatal error: $e\n');
    exit(1);
  }
}
