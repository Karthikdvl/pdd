import 'package:flutter/material.dart';
import 'package:ingreskin/adminPages/feedbackscreen.dart';
import 'package:ingreskin/adminPages/productEditscreen.dart';
import 'package:ingreskin/adminPages/productListScreen.dart';
import 'package:ingreskin/adminPages/reviewScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/list-products': (context) => const ProductListScreen(),
        '/edit-products': (context) => const ProductEditScreen(),
        '/feedback': (context) => const FeedbackScreen(),
        '/reviews': (context) => const ReviewsScreen(),
      },
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align welcome to the left
          children: [
            const Text(
              'Welcome.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(), // Push content to create space between welcome and buttons
            Center( // Center the buttons
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 300,
                    child: DashboardButton(
                      title: 'List products',
                      onPressed: () => Navigator.pushNamed(context, '/list-products'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 300,
                    child: DashboardButton(
                      title: 'View/edit Products',
                      onPressed: () => Navigator.pushNamed(context, '/edit-products'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 300,
                    child: DashboardButton(
                      title: 'User Feedback Collection',
                      onPressed: () => Navigator.pushNamed(context, '/feedback'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 300,
                    child: DashboardButton(
                      title: 'User reviews',
                      onPressed: () => Navigator.pushNamed(context, '/reviews'),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(), // Add space at the bottom to vertically center the buttons
          ],
        ),
      ),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const DashboardButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[300],
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 2,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}