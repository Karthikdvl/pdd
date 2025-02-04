import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ingreskin/config.dart';
import 'package:ingreskin/homeScreenSection/productDetailpage.dart';
import 'package:ingreskin/homepage.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/home': (context) => HomePage(),
        '/search': (context) => SearchResultsPage(),
      },
    );
  }
}

// Search Results Page
class SearchResultsPage extends StatefulWidget {
  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final Map<String, List<dynamic>> _cachedResults = {}; // Cache for search results

  @override
  Widget build(BuildContext context) {
    final String query = ModalRoute.of(context)?.settings.arguments as String? ?? "default";

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "$query"'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchSearchResults(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            Future.delayed(Duration.zero, () {
              _showErrorDialog(context, snapshot.error.toString());
            });
            return Container(); // Return an empty container since the dialog is shown
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(productId: product['id']),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        product['rank'].toString(),
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

  Future<List<dynamic>> _fetchSearchResults(String query) async {
    // If results for the query exist in cache, use cached data
    if (_cachedResults.containsKey(query)) {
      return _cachedResults[query]!;
    }

    // Otherwise, fetch new data
    try {
      final response = await http.get(Uri.parse('$BASE_URL/search?query=$query'));
      if (response.statusCode == 200) {
        final results = json.decode(response.body)['results'];
        if (results == null || results.isEmpty) {
          throw Exception('No products found.');
        }
        _cachedResults[query] = results; // Cache the new results
        return results;
      } else {
        throw Exception('Failed to load search results.');
      }
    } on http.ClientException {
      // Handle connection issues specifically
      throw Exception('Connection error. Please check your network and try again.');
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushNamed(context, '/home'); // Navigate back to the home page
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
