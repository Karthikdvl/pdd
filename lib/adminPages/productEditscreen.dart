import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ingreskin/config.dart';

class ProductEditScreen extends StatefulWidget {
  final int productId;

  const ProductEditScreen({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _product = {};
  bool _isLoading = true;

  Future<void> _fetchProductDetails() async {
    try {
      final response = await http.get(Uri.parse('$BASE_URL/products/${widget.productId}'));
      if (response.statusCode == 200) {
        setState(() {
          _product = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch product details.')),
        );
      }
    } catch (e) {
      print('Error fetching product details: $e');
    }
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    try {
      final response = await http.put(
        Uri.parse('$BASE_URL/products/${widget.productId}'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(_product),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update product.')),
        );
      }
    } catch (e) {
      print('Error updating product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Edit Product ${widget.productId}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _product['name'],
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) => _product['name'] = value,
                validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
              ),
              TextFormField(
                initialValue: _product['brand'],
                decoration: const InputDecoration(labelText: 'Brand'),
                onSaved: (value) => _product['brand'] = value,
              ),
              TextFormField(
                initialValue: _product['label'],
                decoration: const InputDecoration(labelText: 'Label'),
                onSaved: (value) => _product['label'] = value,
              ),
              TextFormField(
                initialValue: _product['price']?.toString(),
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _product['price'] = double.tryParse(value!),
              ),
              TextFormField(
                initialValue: _product['rank']?.toString(),
                decoration: const InputDecoration(labelText: 'Rank'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _product['rank'] = double.tryParse(value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProduct,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
