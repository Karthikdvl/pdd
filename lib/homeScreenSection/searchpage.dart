import 'package:flutter/material.dart';
import 'package:ingreskin/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Search Results Page
class SearchResultsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String query = ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "$query"'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchSearchResults(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found.'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        product['rank'].toString(), // Display rank in avatar
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      product['name'] ?? 'No Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Brand: ${product['brand'] ?? 'N/A'}"),
                        Text("Label: ${product['label'] ?? 'N/A'}"),
                        //Text("Price: \₹${product['price'] ?? '0.00'}"),
                      ],
                    ),
                    trailing: Text(
                      "ID: ${product['id'] ?? 'N/A'}",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Function to fetch search results from the API
  Future<List<dynamic>> fetchSearchResults(String query) async {
  try {
    final response = await http.get(Uri.parse('$BASE_URL/search?query=$query'));
    if (response.statusCode == 200) {
      final results = json.decode(response.body)['results'];
      if (results == null || results.isEmpty) {
        throw Exception('No products found. TRY ANOTHER KEYWORD.');
      }
      return results;
    } else {
      throw Exception('Failed to load search results. TRY ANOTHER KEYWORD.');
    }
  } catch (e) {
    throw Exception('Error fetching data: $e ');
  }
}
}