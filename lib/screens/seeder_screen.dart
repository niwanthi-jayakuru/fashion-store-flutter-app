import 'package:flutter/material.dart';
import '../services/products_seeder.dart';

class SeederScreen extends StatefulWidget {
  const SeederScreen({super.key});

  @override
  State<SeederScreen> createState() => _SeederScreenState();
}

class _SeederScreenState extends State<SeederScreen> {
  bool isLoading = false;
  String? message;
  bool isSuccess = false;

  Future<void> _seedDatabase() async {
    setState(() {
      isLoading = true;
      message = null;
    });

    try {
      await ProductsSeeder.seedProducts();
      setState(() {
        isSuccess = true;
        message = 'Products seeded successfully!';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isSuccess = false;
        message = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _clearDatabase() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Products?'),
        content: const Text('This will delete all products. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() {
                isLoading = true;
                message = null;
              });

              try {
                await ProductsSeeder.clearProducts();
                setState(() {
                  isSuccess = true;
                  message = 'Products cleared successfully!';
                  isLoading = false;
                });
              } catch (e) {
                setState(() {
                  isSuccess = false;
                  message = 'Error: $e';
                  isLoading = false;
                });
              }
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Seeder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Database Seeding Tool',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Populate the database with 10 sample fashion products.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            if (message != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSuccess ? Colors.green[100] : Colors.red[100],
                  border: Border.all(
                    color: isSuccess ? Colors.green : Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message!,
                  style: TextStyle(
                    color: isSuccess ? Colors.green[700] : Colors.red[700],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
            ],
            ElevatedButton.icon(
              onPressed: isLoading ? null : _seedDatabase,
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_upload),
              label: Text(isLoading ? 'Seeding...' : 'Seed Database'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: isLoading ? null : _clearDatabase,
              icon: const Icon(Icons.delete),
              label: const Text('Clear All Products'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 40),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sample Products',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Classic White T-Shirt (\$29.99)\n'
                      '• Denim Jeans Blue (\$59.99)\n'
                      '• Black Casual Hoodie (\$54.99)\n'
                      '• Summer Floral Dress (\$49.99)\n'
                      '• Leather Jacket (\$149.99)\n'
                      '• And 5 more...',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
