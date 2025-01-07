import 'package:flutter/material.dart';
import 'package:ingreskin/homeScreenSection/productDetailpage.dart';

class RecommendedProductsPage extends StatefulWidget {
  final List<dynamic> recommendations;

  const RecommendedProductsPage({Key? key, required this.recommendations}) : super(key: key);

  @override
  _RecommendedProductsPageState createState() => _RecommendedProductsPageState();
}

class _RecommendedProductsPageState extends State<RecommendedProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recommended Products',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: widget.recommendations.isEmpty
          ? const Center(
              child: Text('No recommendations available'),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recommended Products for Your Skin',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.recommendations.length,
                      itemBuilder: (context, index) {
                        final product = widget.recommendations[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product['name'] ?? 'Unknown Product',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Brand: ${product['brand']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Category: ${product['label']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 20),
                                    Text(
                                      ' ${product['rank'].toStringAsFixed(1)}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to ProductDetailPage with productId
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetailPage(productId: product['id']),
                                      ),
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      'View Details',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/home');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.home, color: Colors.white),
      ),
    );
  }
}
