import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ingreskin/config.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> with AutomaticKeepAliveClientMixin {
  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';
  TextEditingController searchController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  Future<void> fetchProducts() async {
    if (!mounted) return;
    
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/productlist'),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['results'] != null && data['results'].isNotEmpty) {
          setState(() {
            products = data['results'];
            filteredProducts = products;
          });
        } else {
          setState(() {
            products = [];
            filteredProducts = [];
            errorMessage = 'No products available.';
            hasError = true;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load products. Server error: ${response.statusCode}';
          hasError = true;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Failed to fetch products. Please check your connection.';
        hasError = true;
      });
    } finally {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterProducts(String query) {
    setState(() {
      filteredProducts = products
          .where((product) =>
              product['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return WillPopScope(
      onWillPop: () async {
        // Refresh data when navigating back
        fetchProducts();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Product List'),
        ),
        body: RefreshIndicator(
          onRefresh: fetchProducts,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Products',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    filterProducts(value);
                  },
                ),
              ),
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : hasError
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  errorMessage,
                                  style: TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: fetchProducts,
                                  child: Text('Retry'),
                                ),
                              ],
                            ),
                          )
                        : filteredProducts.isEmpty
                            ? Center(child: Text('No products found.'))
                            : ListView.builder(
                                itemCount: filteredProducts.length,
                                itemBuilder: (context, index) {
                                  final product = filteredProducts[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 6.0),
                                    child: Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product['name'],
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'ID: ${product['id']}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              'Brand: ${product['brand']}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              'Label: ${product['label']}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    await Navigator.pushNamed(
                                                      context,
                                                      '/productDetail',
                                                      arguments: product['id'],
                                                    ).then((_) => fetchProducts());
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.blueAccent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                  child: Text('View Details'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}