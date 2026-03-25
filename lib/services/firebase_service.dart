import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get all products
  Future<List<Product>> getProducts() async {
    try {
      final snapshot = await _db.collection('products').get();
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final snapshot = await _db
          .collection('products')
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching products by category: $e');
      return [];
    }
  }

  // Get all categories
  Future<List<String>> getCategories() async {
    try {
      final snapshot = await _db.collection('products').get();
      final categories = <String>{};
      for (var doc in snapshot.docs) {
        final category = doc['category'] as String?;
        if (category != null) categories.add(category);
      }
      return categories.toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  // Get orders for current user
  Future<List<Map<String, dynamic>>> getOrderHistory() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final snapshot = await _db
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  // Update user profile
  Future<bool> updateUserProfile({
    required String displayName,
    required String phone,
    required String address,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await user.updateDisplayName(displayName);
      await _db.collection('users').doc(user.uid).set({
        'displayName': displayName,
        'email': user.email,
        'phone': phone,
        'address': address,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return true;
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _db.collection('users').doc(user.uid).get();
      return doc.data();
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }
}
