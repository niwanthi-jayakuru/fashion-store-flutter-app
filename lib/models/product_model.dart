class Product {
  final String id;
  final String name;
  final double price;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  factory Product.fromFirestore(doc) {
    final data = doc.data();
    return Product(
      id: doc.id,
      name: data['name'],
      price: (data['price']).toDouble(),
      image: data['image'],
    );
  }
}