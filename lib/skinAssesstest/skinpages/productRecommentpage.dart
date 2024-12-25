import 'package:flutter/material.dart';

class RecommendedProductsPage extends StatelessWidget {
  final List<dynamic> recommendations; // Accept the list of recommendations

  const RecommendedProductsPage({Key? key, required this.recommendations}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Products'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: recommendations.length,
          itemBuilder: (context, index) {
            final product = recommendations[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text(product["name"] as String), // Cast to String
                subtitle: Text(
                  "Brand: ${product["brand"] as String}\nPrice: ${product["price"] as String}",
                ),
                trailing: Text("⭐ ${(product["rank"] as double).toString()}"), // Cast to double, then String
              ),
            );
          },
        ),
      ),
    );
  }
}
