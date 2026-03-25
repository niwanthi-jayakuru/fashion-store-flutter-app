import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/cart_service.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final CartService _cartService = CartService();
  bool _isLoading = false;

  @override
  dispose() {
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      final success = await _cartService.placeOrder(
        userId: user.uid,
        address: addressController.text.trim(),
        phone: phoneController.text.trim(),
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Order placed successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, '/home');
        });
      } else {
        throw Exception('Failed to place order');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _cartService.getCartTotal();

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Delivery Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return "Phone is required";
                  if (value!.length < 10) return "Enter a valid phone number";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Delivery Address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return "Address is required";
                  if (value!.length < 10) return "Enter a complete address";
                  return null;
                },
              ),
              const SizedBox(height: 32),
              const Text(
                "Order Summary",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Items:", style: TextStyle(fontSize: 16)),
                        Text("${_cartService.getItemCount()} items",
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Subtotal:", style: TextStyle(fontSize: 16)),
                        Text("\$${total.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("\$${total.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _placeOrder,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text("Place Order",
                          style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: const Text("Continue Shopping"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
