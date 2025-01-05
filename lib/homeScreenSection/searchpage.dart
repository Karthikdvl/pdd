import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ingreskin/config.dart';
import 'package:ingreskin/homeScreenSection/productDetailpage.dart';

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SearchResultsPage(),
      },
    );
  }
}

// Search Results Page
class SearchResultsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String query = ModalRoute.of(context)?.settings.arguments as String? ?? "default";

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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(),
                        ),
                      );
                    },
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
      throw Exception('Error fetching data: $e');
    }
  }
// }

// // Product Detail Page
// class ProductDetailPage extends StatelessWidget {
//   final Map<String, dynamic> product;

//   const ProductDetailPage({Key? key, required this.product}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image Section with Back Button
//             Container(
//               width: double.infinity,
//               height: MediaQuery.of(context).size.width,
//               child: Stack(
//                 children: [
//                   // Product Image
//                   Container(
//                     width: double.infinity,
//                     height: double.infinity,
//                     child: Image.network(
//                       product['image'] ?? 'https://via.placeholder.com/150',
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   // Safe Area for Back Button
//                   SafeArea(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: IconButton(
//                         icon: const Icon(Icons.arrow_back),
//                         onPressed: () => Navigator.pop(context),
//                         style: IconButton.styleFrom(
//                           backgroundColor: Colors.grey[200],
//                           shape: const CircleBorder(),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Product Name
//             Center(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 16.0),
//                 child: Text(
//                   product['name'] ?? 'Product Name',
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),

//             // Safety Rating Section
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Safety rating',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Rating: ${product['rating'] ?? 'N/A'}',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Description Section
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Description',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     product['description'] ?? 'No description available.',
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
 }
