import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:ingreskin/aiAssistant/pages/AI_homePage.dart';
import 'package:ingreskin/homeScreenSection/productExpirytracker.dart';
import 'package:ingreskin/homeScreenSection/searchpage.dart';
import 'package:ingreskin/homeScreenSection/testextractor.dart';
import 'package:ingreskin/profilepage.dart';
import 'package:ingreskin/skinAssesstest/skinpages/navi.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => HomePage(),
        '/navigation': (context) => NavigationBarPage(),
        '/profile': (context) => ProfilePage(),
        '/product-expiry': (context) => ProductExpiryTrackerPage(),
        '/photo': (context) => TextExtractorScreen(),
        '/aiAssistant': (context) =>  AIassistant(),
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
  String? userName;
  String? userEmail;

  final PageController _pageController =
      PageController(); // PageController for PageView
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
    _startAutoScroll(); // Start the auto-scrolling
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'User';
      userEmail = prefs.getString('userEmail') ?? 'No email provided';
    });
  }

  void _searchProducts() async {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Navigator.pushNamed(context, '/search-results', arguments: query);
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 7), (timer) {
      // Changed to 8 seconds
      if (_pageController.hasClients) {
        final nextPage = (_pageController.page ?? 0) + 1;
        _pageController.animateToPage(
          nextPage.toInt() % 4, // Loop back to the first image after the last
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
      }
    });
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
              Navigator.pushNamed(
                context,
                '/profile',
                arguments: {'name': userName, 'email': userEmail},
              );
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
              Text(
                'Welcome, $userName',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              // Text(
              //   'Email: $userEmail',
              //   style: TextStyle(
              //     fontSize: 16,
              //     color: Colors.grey[700],
              //   ),
              // ),
              // SizedBox(height: 24),
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
              // PageView for Auto-Sliding Ads Section with increased size
              SizedBox(
                height: 220, // Increased height for ads cards
                child: PageView(
                  controller: _pageController,
                  children: [
                    AdImage(imageUrl: 'assets/ad1.png'),
                    AdImage(imageUrl: 'assets/ad2.png'),
                    AdImage(imageUrl: 'assets/ad3.png'),
                    AdImage(imageUrl: 'assets/ad4.png'),
                  ],
                ),
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
              Navigator.pushNamed(
                  context, '/aiAssistant'); // Navigate to AI Assistant
              break;
          }
        },
      ),
    );
  }
}

// AdImage Widget for Ads
class AdImage extends StatelessWidget {
  final String imageUrl;

  AdImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
