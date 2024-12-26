import 'package:flutter/material.dart';
import 'package:ingreskin/adminPages/adminDashboard.dart';
import 'package:ingreskin/adminPages/admin_forgot_password.dart';
import 'package:ingreskin/adminPages/feedbackscreen.dart';
import 'package:ingreskin/adminPages/productEditscreen.dart';
import 'package:ingreskin/adminPages/productListScreen.dart';
import 'package:ingreskin/adminPages/productdetaliscreen.dart';
import 'package:ingreskin/adminPages/reviewScreen.dart';
import 'package:ingreskin/aiAssistant/pages/AI_homePage.dart';
import 'package:ingreskin/homeScreenSection/imageSearch.dart';
import 'package:ingreskin/homeScreenSection/productExpirytracker.dart';
import 'package:ingreskin/homeScreenSection/searchpage.dart';
import 'package:ingreskin/homepage.dart';
import 'package:ingreskin/profilepage.dart';
import 'package:ingreskin/skinAssesstest/skinpages/navi.dart';
import 'package:ingreskin/skinAssesstest/skinpages/page1_personal_details.dart';
import 'package:ingreskin/skinAssesstest/userModel/userdatamodel.dart';
import 'dart:async';
import 'getstartedpage.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:ingreskin/aiAssistant/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(
    apiKey: GEMINI_API_KEY,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    UserSkinData userSkinData = UserSkinData();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const DashboardScreen() : const SplashScreen(),
      //     onGenerateRoute: (settings) {
      //   // Check if the route is for ProductDetailScreen
      //   if (settings.name == '/productDetail') {
      //     final product = settings.arguments;  // Get the 'product' from arguments
      //     return MaterialPageRoute(
      //       builder: (context) => ProductDetailScreen(product: product),
      //     );
      //   }

      //   // Add other route handling as needed
      //   return null;
      // },
      routes: {
        '/list-products': (context) => ProductListScreen(),
        //'/edit-products': (context) => const ProductEditScreen(),
        '/edit-products': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          print('Arguments received: $args');
          if (args == null || args is! Map<String, dynamic>) {
            return Scaffold(
              body: Center(child: Text('Invalid or missing arguments')),
            );
          }
          return ProductEditScreen(productId: args['productId']);
        },

        '/feedback': (context) => const FeedbackScreen(),
        '/reviews': (context) => const ReviewsScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/forgot-password': (context) => const AdminForgotPasswordScreen(),
        '/home': (context) => HomePage(),
        '/navigation': (context) => NavigationBarPage(),
        '/skin-assessment': (context) =>
            PersonalDetailsPage(userSkinData: userSkinData),
        '/profile': (context) => ProfilePage(),
        '/product-expiry': (context) => ProductExpiryTrackerPage(),
        '/photo': (context) => PhotoSearchScreen(),
        '/aiAssistant': (context) => AIassistant(),
        '/search-results': (context) => SearchResultsPage(),
        '/get-started': (context) => GetStartedPage(),
        //'/productDetail': (context) => ProductDetailScreen(),
        '/productDetail': (context) {
          final productId = ModalRoute.of(context)!.settings.arguments
              as int; // Changed to int
          return ProductDetailScreen(productId: productId);
        },
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
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/get-started');
    }
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/logo1.png',
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
              child: CircularProgressIndicator(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
