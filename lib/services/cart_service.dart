import '../models/product.dart';

class CartService {
  static List<Product> cart = [];

  static void addToCart(Product product) {
    cart.add(product);
  }
}