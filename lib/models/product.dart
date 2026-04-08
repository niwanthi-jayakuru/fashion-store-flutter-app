import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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


  String get displayImageUrl {
    final u = image.trim();
    if (u.isEmpty) {
      final seed = id.isNotEmpty ? id : 'p${name.hashCode}';
      return 'https://picsum.photos/seed/${Uri.encodeComponent(seed)}/400/400';
    }
    return u;
  }

  static Map<String, String>? networkHeadersFor(String url) {
    if (kIsWeb) return null;
    try {
      final host = Uri.parse(url).host.toLowerCase();
      if (host.contains('unsplash.com')) {
        return {'Referer': 'https://unsplash.com/'};
      }
    } catch (_) {}
    return null;
  }

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
