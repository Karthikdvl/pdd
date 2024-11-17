import 'package:flutter/material.dart';

class ProductEditScreen extends StatelessWidget {
  const ProductEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Products'),
      ),
      body: ListView.builder(
        itemCount: 10, // Example count
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Product ${index + 1}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Handle edit action
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add new product
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}