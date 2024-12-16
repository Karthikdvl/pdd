// homeScreenSection/product_expiry_tracker_page.dart
import 'package:flutter/material.dart';
import 'package:ingreskin/homeScreenSection/addProductPage.dart';
import 'package:ingreskin/homeScreenSection/models/productItem.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Optional: Disable the debug banner
      title: 'Product Expiry Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProductExpiryTrackerPage(),
    );
  }
}

class ProductExpiryTrackerPage extends StatefulWidget {
  const ProductExpiryTrackerPage({Key? key}) : super(key: key);

  @override
  _ProductExpiryTrackerPageState createState() =>
      _ProductExpiryTrackerPageState();
}

class _ProductExpiryTrackerPageState extends State<ProductExpiryTrackerPage> {
  final List<ProductItem> _products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Expiry Tracker'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Skincare Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(_products[index], index);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewProduct,
        child: const Icon(Icons.add),
        backgroundColor: Colors.grey[700],
      ),
    );
  }

  Widget _buildProductCard(ProductItem product, int index) {
    final daysRemaining = product.expiryDate.difference(DateTime.now()).inDays;
    Color statusColor = _getStatusColor(daysRemaining);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      product.brand,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _removeProduct(index),
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Opened: ${DateFormat('MMM dd, yyyy').format(product.openedDate)}',
                ),
                Text(
                  'Expires: ${DateFormat('MMM dd, yyyy').format(product.expiryDate)}',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '$daysRemaining days remaining',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _buildStatusIndicator(statusColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(Color color) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  Color _getStatusColor(int daysRemaining) {
    if (daysRemaining <= 30) return Colors.red;
    if (daysRemaining <= 60) return Colors.orange;
    return Colors.green;
  }

  void _addNewProduct() async {
    final result = await Navigator.push<ProductItem>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddProductPage(),
      ),
    );
    if (result != null) {
      setState(() {
        _products.add(result);
      });
    }
  }

  void _removeProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }
}
