import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get subtotal => product.price * quantity;

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
      };
}

class CartService {
  static final CartService _instance = CartService._internal();
  final Map<String, CartItem> _cartItems = {};
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _storageKey = 'cart_v1';
  bool _isInitialized = false;

  factory CartService() {
    return _instance;
  }

  CartService._internal();

  Future<void> init() async {
    if (_isInitialized) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      _isInitialized = true;
      return;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        _isInitialized = true;
        return;
      }

      _cartItems.clear();
      for (final entry in decoded) {
        if (entry is! Map) continue;
        final map = entry.cast<String, dynamic>();
        final productMap = map['product'];
        final quantity = (map['quantity'] as num?)?.toInt() ?? 1;
        if (productMap is! Map) continue;

        final product = _productFromJson(productMap.cast<String, dynamic>());
        _cartItems[product.id] = CartItem(
          product: product,
          quantity: quantity <= 0 ? 1 : quantity,
        );
      }
    } catch (_) {
      _cartItems.clear();
    } finally {
      _isInitialized = true;
    }
  }

  Product _productFromJson(Map<String, dynamic> map) {
    return Product(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      price: (map['price'] ?? 0).toDouble(),
      image: (map['image'] ?? '').toString(),
      category: (map['category'] ?? 'Uncategorized').toString(),
      description: (map['description'] ?? '').toString(),
    );
  }

  Future<void> _persist() async {
    if (!_isInitialized) {
      // If init wasn't called explicitly, do a best-effort init before saving.
      await init();
    }
    final prefs = await SharedPreferences.getInstance();
    final list = _cartItems.values.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(list));
  }

  // Add or update product in cart
  void addToCart(Product product, {int quantity = 1}) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems[product.id]!.quantity += quantity;
    } else {
      _cartItems[product.id] = CartItem(product: product, quantity: quantity);
    }
    _persist();
  }

  // Remove product from cart
  void removeFromCart(String productId) {
    _cartItems.remove(productId);
    _persist();
  }

  // Update quantity
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
    } else if (_cartItems.containsKey(productId)) {
      _cartItems[productId]!.quantity = quantity;
      _persist();
    }
  }

  // Get all cart items
  List<CartItem> getCartItems() => _cartItems.values.toList();

  // Get cart total
  double getCartTotal() =>
      _cartItems.values.fold(0, (sum, item) => sum + item.subtotal);

  // Get item count
  int getItemCount() => _cartItems.length;

  // Clear cart
  void clearCart() {
    _cartItems.clear();
    _persist();
  }

  // Check if product in cart
  bool isInCart(String productId) => _cartItems.containsKey(productId);

  // Place order (save to Firestore)
  Future<bool> placeOrder({
    required String userId,
    required String address,
    required String phone,
  }) async {
    try {
      if (_cartItems.isEmpty) return false;

      await _db.collection('orders').add({
        'userId': userId,
        'items': _cartItems.values.map((item) => item.toJson()).toList(),
        'total': getCartTotal(),
        'address': address,
        'phone': phone,
        'status': 'Pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      clearCart();
      return true;
    } catch (e) {
      print('Error placing order: $e');
      return false;
    }
  }
}
