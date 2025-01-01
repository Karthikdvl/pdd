import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ingreskin/aiAssistant/pages/AI_homePage.dart';
import 'package:ingreskin/config.dart';
import 'package:ingreskin/homeScreenSection/imageSearch.dart';
import 'package:ingreskin/homeScreenSection/productExpirytracker.dart';
import 'package:ingreskin/homeScreenSection/searchpage.dart';
import 'package:ingreskin/homeScreenSection/testextractor.dart';
import 'package:ingreskin/profilepage.dart';
//import 'package:ingreskin/skinAssessment/navigationbar.dart';
import 'package:ingreskin/skinAssessment/skinAssessment.dart';
import 'package:ingreskin/skinAssesstest/skinpages/navi.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => HomePage(),
        '/navigation': (context) => NavigationBarPage(),
        '/skin-assessment': (context) => SkinAssessmentScreen(),
        '/profile': (context) => ProfilePage(),
        '/product-expiry': (context) => ProductExpiryTrackerPage(),
        '/photo': (context) => TextExtractorScreen(),
        '/aiAssistant': (context) => AIassistant(),
        '/search-results': (context) => SearchResultsPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  void _searchProducts() async {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Navigator.pushNamed(context, '/search-results', arguments: query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(context, '/navigation');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                onSubmitted: (_) => _searchProducts(),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: Colors.grey),
                    onPressed: _searchProducts,
                  ),
                  hintText: 'Search products',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Ads',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12),
              AdCard(
                imageUrl: 'assets/Rectangle568.png',
                name: 'Sample Product',
                description: 'This is a description of the product.',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch_later), // Product Expiry Tracker Icon
            label: 'Expiry Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Photo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy), // AI Assistant Icon
            label: 'AI Assistant',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/product-expiry');
              break;
            case 2:
              Navigator.pushNamed(context, '/photo');
              break;
            case 3:
              Navigator.pushNamed(context, '/aiAssistant'); // Navigate to AI Assistant
              break;
          }
        },
      ),
    );
  }
}


// AdCard Widget remains the same
class AdCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String description;

  AdCard({
    required this.imageUrl,
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.asset(
              imageUrl,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
