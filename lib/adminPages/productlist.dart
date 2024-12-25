// // ProductListScreen.dart

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert'; // Import the new file

// import 'package:ingreskin/config.dart';

// class ProductListScreen extends StatefulWidget {
//   @override
//   _ProductListScreenState createState() => _ProductListScreenState();
// }

// class _ProductListScreenState extends State<ProductListScreen> {
//   List<dynamic> products = [];
//   List<dynamic> filteredProducts = [];
//   bool isLoading = false;
//   TextEditingController searchController = TextEditingController();

//   Future<void> fetchProducts() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final response = await http.get(
//         Uri.parse('$BASE_URL/productlist'),
//       );

//       // Log the response body to check the data structure
//       print(response.body); 

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         if (data['results'] != null && data['results'].isNotEmpty) {
//           setState(() {
//             products = data['results'];
//             filteredProducts = products; // Initially display all products
//           });
//         } else {
//           setState(() {
//             products = [];
//             filteredProducts = [];
//           });
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text('No products available.'),
//           ));
//         }
//       } else {
//         setState(() {
//           products = [];
//           filteredProducts = [];
//         });
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Failed to load products.'),
//         ));
//       }
//     } catch (e) {
//       print('Error fetching products: $e');
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Failed to fetch products.'),
//       ));
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void filterProducts(String query) {
//     setState(() {
//       filteredProducts = products
//           .where((product) =>
//               product['name'].toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchProducts(); // Fetch all products when the screen loads
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Product List'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 labelText: 'Search Products',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.search),
//               ),
//               onChanged: (value) {
//                 filterProducts(value);
//               },
//             ),
//           ),
//           Expanded(
//             child: isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : filteredProducts.isEmpty
//                     ? Center(child: Text('No products found.'))
//                     : ListView.builder(
//                         itemCount: filteredProducts.length,
//                         itemBuilder: (context, index) {
//                           final product = filteredProducts[index];
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 12.0, vertical: 6.0),
//                             child: Card(
//                               elevation: 4,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       product['name'],
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.blueAccent,
//                                       ),
//                                     ),
//                                     SizedBox(height: 8),
//                                     Text(
//                                       'ID: ${product['id']}',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                     Text(
//                                       'Brand: ${product['brand']}',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                     Text(
//                                       'Label: ${product['label']}',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.grey[600],
//                                       ),
//                                     ),
//                                     SizedBox(height: 8),
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         ElevatedButton(
//                                           onPressed: () {
//                                             Navigator.pushNamed(
//                                               context,
//                                               '/productDetail',
//                                               arguments: product,
//                                             );
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: Colors.blueAccent,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                             ),
//                                           ),
//                                           child: Text('View Details'),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }
// }
