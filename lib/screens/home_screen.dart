import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../services/cart_service.dart';
import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService service = FirebaseService();
  final CartService _cartService = CartService();
  String? _selectedCategory;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    final categories = await service.getCategories();
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fashion Store"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _selectedCategory == null
            ? service.getProducts()
            : service.getProductsByCategory(_selectedCategory!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No products found"));
          }

          final products = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_categories.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () =>
                              setState(() => _selectedCategory = null),
                          child: Text(
                            'All',
                            style: TextStyle(
                              color: _selectedCategory == null
                                  ? Colors.blueGrey
                                  : Colors.black54,
                            ),
                          ),
                        ),
                        ..._categories.map((category) {
                          final isSelected = _selectedCategory == category;
                          return TextButton(
                            onPressed: () => setState(() => _selectedCategory =
                                isSelected ? null : category),
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.blueGrey
                                    : Colors.black54,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Products',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 12, thickness: 1),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ListTile(
                      tileColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      leading: SizedBox(
                        width: 58,
                        height: 58,
                        child: Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported),
                        ),
                      ),
                      title: Text(product.name,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                      onTap: () {
                        Navigator.pushNamed(context, '/productDetails',
                            arguments: product);
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          _cartService.addToCart(product);
                          final snack = SnackBar(
                              content: Text('Added ${product.name} to cart'));
                          ScaffoldMessenger.of(context).showSnackBar(snack);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
