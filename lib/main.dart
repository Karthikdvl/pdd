import 'package:flutter/material.dart';
import 'package:ingreskin/adminPages/feedbackscreen.dart';
import 'package:ingreskin/adminPages/productEditscreen.dart';
import 'package:ingreskin/adminPages/productListScreen.dart';
import 'package:ingreskin/adminPages/reviewScreen.dart';
import 'package:ingreskin/aiAssistant/pages/AI_homePage.dart';
import 'package:ingreskin/homeScreenSection/productExpirytracker.dart';
import 'package:ingreskin/homepage.dart';
import 'package:ingreskin/skinAssesstest/skinpages/navi.dart'; // Navigation bar
import 'package:ingreskin/skinAssesstest/skinpages/page1_personal_details.dart';
import 'package:ingreskin/skinAssesstest/userModel/userdatamodel.dart'; // Import UserSkinData
import 'dart:async'; // Import for Timer
import 'getstartedpage.dart'; // Import your GetStartedPage file
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:ingreskin/aiAssistant/consts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(
    apiKey: GEMINI_API_KEY, // Replace with your actual API key
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a UserSkinData instance for skin assessment
    UserSkinData userSkinData = UserSkinData();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/list-products': (context) => const ProductListScreen(),
        '/edit-products': (context) => const ProductEditScreen(),
        '/feedback': (context) => const FeedbackScreen(),
        '/reviews': (context) => const ReviewsScreen(),
        '/home': (context) => HomePage(),
        '/navigation': (context) => NavigationBarPage(/*userSkinData: userSkinData*/),
        '/skin-assessment': (context) => PersonalDetailsPage(userSkinData: userSkinData),
        '/profile': (context) => ProfilePage(user: {}),
        '/product-expiry': (context) => ProductExpiryTrackerPage(),
        '/photo': (context) => PhotoPage(),
        '/aiAssistant': (context) => AIassistant(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 3 seconds and navigate to GetStartedPage
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GetStartedPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with rounded corners
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/logo1.png', // Replace with actual logo path
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: CircularProgressIndicator(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
