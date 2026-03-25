import 'package:cloud_firestore/cloud_firestore.dart';
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
        'productId': product.id,
        'name': product.name,
        'price': product.price,
        'image': product.image,
        'quantity': quantity,
      };
}

class CartService {
  static final CartService _instance = CartService._internal();
  final Map<String, CartItem> _cartItems = {};
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  factory CartService() {
    return _instance;
  }

  CartService._internal();

  // Add or update product in cart
  void addToCart(Product product, {int quantity = 1}) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems[product.id]!.quantity += quantity;
    } else {
      _cartItems[product.id] = CartItem(product: product, quantity: quantity);
    }
  }

  // Remove product from cart
  void removeFromCart(String productId) {
    _cartItems.remove(productId);
  }

  // Update quantity
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
    } else if (_cartItems.containsKey(productId)) {
      _cartItems[productId]!.quantity = quantity;
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
