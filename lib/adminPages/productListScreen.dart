import 'package:flutter/material.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: ListView.builder(
        itemCount: 10, // Example count
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Product ${index + 1}'),
            subtitle: Text('Product Description ${index + 1}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle product selection
            },
          );
        },
      ),
    );
  }
}