import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../services/cart_service.dart';
import '../models/product.dart';
import '../widgets/product_image.dart';

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

  /// First few catalog items when browsing “All” (no category filter).
  Widget _buildFeaturedRow(BuildContext context, List<Product> products) {
    final featured = products.take(4).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Featured',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 188,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: featured.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final product = featured[index];
              return SizedBox(
                width: 140,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/productDetails',
                          arguments: product);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 110,
                          child: ProductImage(
                            product: product,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.pink[400],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
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
          final showFeatured = _selectedCategory == null && products.isNotEmpty;

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
                        }),
                      ],
                    ),
                  ),
                ),
              if (showFeatured) _buildFeaturedRow(context, products),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Products',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/products'),
                      child: const Text('See all products'),
                    ),
                  ],
                ),
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
                      mouseCursor: SystemMouseCursors.basic,
                      tileColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      leading: SizedBox(
                        width: 58,
                        height: 58,
                        child: ProductImage(product: product),
                      ),
                      title: Text(product.name,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                      onTap: () {
                        Navigator.pushNamed(context, '/productDetails',
                            arguments: product);
                      },
                      trailing: IconButton(
                        mouseCursor: SystemMouseCursors.basic,
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
