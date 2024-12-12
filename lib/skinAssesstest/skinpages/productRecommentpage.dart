import 'package:flutter/material.dart';
import 'package:ingreskin/skinAssesstest/userModel/userdatamodel.dart'; // Import UserSkinData

class RecommendedProductsPage extends StatelessWidget {
  final UserSkinData userSkinData; // Accept UserSkinData instance

  const RecommendedProductsPage({Key? key, required this.userSkinData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy recommendations for demonstration
    final recommendedProducts = [
      {"name": "Hydrating Serum", "brand": "Brand A", "price": "\$25", "rank": 4.8},
      {"name": "Moisturizing Cream", "brand": "Brand B", "price": "\$30", "rank": 4.5},
      {"name": "Anti-Aging Oil", "brand": "Brand C", "price": "\$40", "rank": 4.7},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Products'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: recommendedProducts.length,
          itemBuilder: (context, index) {
            final product = recommendedProducts[index];
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
