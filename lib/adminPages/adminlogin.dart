import 'package:flutter/material.dart';
import 'package:ingreskin/adminPages/adminDashboard.dart';
import 'package:ingreskin/adminPages/admin_forgot_password.dart';
import 'package:ingreskin/adminPages/feedbackscreen.dart';
import 'package:ingreskin/adminPages/productEditscreen.dart';
import 'package:ingreskin/adminPages/productListScreen.dart';
import 'package:ingreskin/adminPages/reviewScreen.dart';

void main() {
  runApp(const AdminLoginApp());
}

class AdminLoginApp extends StatelessWidget {
  const AdminLoginApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminLoginScreen(),
      routes: {
        '/list-products': (context) => const ProductListScreen(),
        '/edit-products': (context) => const ProductEditScreen(),
        '/feedback': (context) => const FeedbackScreen(),
        '/reviews': (context) => const ReviewsScreen(),
      },
    );
  }
}

class AdminLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Admin Login', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Handle forgot password
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminForgotPassword(),
                          ),
                        );
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle login
                Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DashboardScreen(),
                          ),
                        );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 18,
                color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
