import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class OrderHistoryScreen extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order History")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _firebaseService.getOrderHistory(),
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          // Empty
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text(
                    "No orders yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/home'),
                    child: const Text("Start Shopping"),
                  )
                ],
              ),
            );
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final items = order['items'] as List<dynamic>? ?? [];
              final total = order['total'] ?? 0;
              final status = order['status'] ?? 'Unknown';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: ExpansionTile(
                  title: Text(
                    "Order #${(index + 1).toString().padLeft(3, '0')}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    "\$${total.toStringAsFixed(2)} • $status",
                    style: TextStyle(
                      color:
                          status == 'Delivered' ? Colors.green : Colors.orange,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Items
                          const Text(
                            "Items:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          ...items.map((item) {
                            final itemData = item as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                        "${itemData['name']} x${itemData['quantity']}"),
                                  ),
                                  Text(
                                    "\$${(itemData['price'] * itemData['quantity']).toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          const Divider(),
                          // Order Summary
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Delivery Address:"),
                                    Expanded(
                                      child: Text(
                                        order['address'] ?? 'N/A',
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Phone:"),
                                    Text(
                                      order['phone'] ?? 'N/A',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          // Total & Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "\$${total.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: status == 'Delivered'
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                              child: Text(status),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
