import 'package:flutter/material.dart';
import 'package:ingreskin/config.dart';
import 'package:ingreskin/homeScreenSection/addProductPage.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductItem {
  final int id;
  final String name;
  final String brand;
  final DateTime openedDate;
  final DateTime expiryDate;

  ProductItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.openedDate,
    required this.expiryDate,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['id'] as int,
      name: json['name'] as String,
      brand: json['brand'] as String,
      openedDate: DateTime.parse(json['opened_date'] as String),
      expiryDate: DateTime.parse(json['expiry_date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'opened_date': openedDate.toIso8601String(),
      'expiry_date': expiryDate.toIso8601String(),
    };
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
  String? _userEmail;
  final String _baseUrl = '$BASE_URL';

  @override
  void initState() {
    super.initState();
    _loadUserEmail().then((_) {
      if (_userEmail != null) {
        _loadProductTracking();
      }
    });
  }

  Future<void> _loadUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _userEmail = prefs.getString('userEmail');
      });
    } catch (e) {
      print('Error loading user email from SharedPreferences: $e');
    }
  }

  Future<void> _loadProductTracking() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_product_tracking?user_email=$_userEmail'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _products.addAll(data.map((json) => ProductItem.fromJson(json)).toList());
        });
      }
    } catch (e) {
      print('Error fetching product tracking data: $e');
    }
  }

  Future<void> _addProductToBackend(ProductItem product) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/add_product_tracking'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          ...product.toJson(),
          'user_email': _userEmail,
        }),
      );

      if (response.statusCode == 201) {
        print('Product added successfully!');
      } else {
        print('Failed to add product: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding product: $e');
    }
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
      _addProductToBackend(result);
    }
  }

  void _removeProduct(int index) async {
    final product = _products[index];
    try {
      await _removeProductFromBackend(product.id);
      setState(() {
        _products.removeAt(index);
      });
      print('Product removed from backend and list.');
    } catch (e) {
      print('Error removing product: $e');
    }
  }

  Future<void> _removeProductFromBackend(int productId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/remove_product_tracking/$productId'),
      );

      if (response.statusCode == 200) {
        print('Product removed successfully!');
      } else {
        print('Failed to remove product: ${response.statusCode}');
      }
    } catch (e) {
      print('Error removing product: $e');
    }
  }

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
            Text(
              'ID: ${product.id}', // Display the ID
              style: const TextStyle(fontSize: 14, color: Colors.grey),
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
}
