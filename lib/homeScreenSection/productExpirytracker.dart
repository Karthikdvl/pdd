import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this to pubspec.yaml for date formatting

class ProductExpiryTrackerPage extends StatefulWidget {
  const ProductExpiryTrackerPage({Key? key}) : super(key: key);

  @override
  _ProductExpiryTrackerPageState createState() => _ProductExpiryTrackerPageState();
}

class _ProductExpiryTrackerPageState extends State<ProductExpiryTrackerPage> {
  // Sample product data - you would typically fetch this from a database
  final List<ProductItem> _products = [
    ProductItem(
      name: 'Moisturizer',
      brand: 'Neutrogena',
      openedDate: DateTime.now().subtract(Duration(days: 90)),
      expiryDate: DateTime.now().add(Duration(days: 180)),
    ),
    ProductItem(
      name: 'Serum',
      brand: 'The Ordinary',
      openedDate: DateTime.now().subtract(Duration(days: 60)),
      expiryDate: DateTime.now().add(Duration(days: 120)),
    ),
    ProductItem(
      name: 'Sunscreen',
      brand: 'La Roche-Posay',
      openedDate: DateTime.now().subtract(Duration(days: 30)),
      expiryDate: DateTime.now().add(Duration(days: 270)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Expiry Tracker'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Skincare Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(_products[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewProduct,
        child: Icon(Icons.add),
        backgroundColor: Colors.grey[700],
      ),
    );
  }

  Widget _buildProductCard(ProductItem product) {
    final daysRemaining = product.expiryDate.difference(DateTime.now()).inDays;
    Color statusColor = _getStatusColor(daysRemaining);

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  product.brand,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Opened: ${DateFormat('MMM dd, yyyy').format(product.openedDate)}',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  'Expires: ${DateFormat('MMM dd, yyyy').format(product.expiryDate)}',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '$daysRemaining days remaining',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
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

  void _addNewProduct() {
    // Implement a dialog or navigation to add a new product
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Product'),
          content: Text('Product addition functionality to be implemented'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class ProductItem {
  final String name;
  final String brand;
  final DateTime openedDate;
  final DateTime expiryDate;

  ProductItem({
    required this.name,
    required this.brand,
    required this.openedDate,
    required this.expiryDate,
  });
}