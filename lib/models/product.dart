import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  final String category;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    this.description = '',
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      image: data['image'] ?? '',
      category: data['category'] ?? 'Uncategorized',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'image': image,
        'category': category,
        'description': description,
      };
}
