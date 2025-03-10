import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ingreskin/config.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;

  ProductDetailPage({required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Product Details', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchProductDetails(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No details found.'));
          } else {
            final product = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'] ?? 'No Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.branding_watermark, color: Colors.blueAccent),
                              SizedBox(width: 8),
                              Text("Brand: ${product['brand'] ?? 'N/A'}"),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.label, color: Colors.green),
                              SizedBox(width: 8),
                              Text("Label: ${product['label'] ?? 'N/A'}"),
                            ],
                          ),
                          SizedBox(height: 10),
                          // Row(
                          //   children: [
                          //     Icon(Icons.monetization_on, color: Colors.orange),
                          //     SizedBox(width: 8),
                          //     Text("Price: \$${product['price'] ?? 'N/A'}"),
                          //   ],
                          // ),
                          // SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.star_rate, color: Colors.yellow),
                              SizedBox(width: 8),
                              Text("Rank: ${product['rank'] ?? 'N/A'}"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Ingredients:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blueAccent),
                  ),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        product['ingredients'] ?? 'N/A',
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> fetchProductDetails(int productId) async {
    try {
      final response = await http.get(Uri.parse('$BASE_URL/api/product/$productId'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load product details.');
      }
    } catch (e) {
      throw Exception('Error fetching product details: $e');
    }
  }
}
