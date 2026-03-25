import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Product>> getProducts() async {
    final snapshot = await _db.collection('products').get();

    return snapshot.docs
        .map((doc) => Product.fromFirestore(doc))
        .toList();
  }
}