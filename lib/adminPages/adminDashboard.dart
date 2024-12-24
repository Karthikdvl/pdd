import 'package:flutter/material.dart';
import 'package:ingreskin/adminPages/feedbackscreen.dart';
import 'package:ingreskin/adminPages/productEditscreen.dart';
import 'package:ingreskin/adminPages/productListScreen.dart';
import 'package:ingreskin/adminPages/reviewScreen.dart';
import 'package:http/http.dart' as http;
import 'package:ingreskin/config.dart';
import 'package:ingreskin/getstartedpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
// void main() {
//   runApp(const MyApp());
// }

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
        '/get-started': (context) => GetStartedPage(),
      },
    );
  }
}


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

 Future<void> _logout(BuildContext context) async {
  final response = await http.post(
    Uri.parse('$BASE_URL/admin/logout'),
  );

  if (response.statusCode == 200) {
    // Clear login state
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    // Navigate to GetStartedPage and clear the navigation stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) =>  GetStartedPage()),
      (route) => false,
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logout failed')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome, Admin!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildDashboardCard(
                  context,
                  icon: Icons.list_alt,
                  title: 'Product List',
                  onTap: () {
                    Navigator.pushNamed(context, '/list-products');
                  },
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.edit,
                  title: 'Edit Products',
                  onTap: () {
                    Navigator.pushNamed(context, '/edit-products');
                  },
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.feedback,
                  title: 'Feedback',
                  onTap: () {
                    Navigator.pushNamed(context, '/feedback');
                  },
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.rate_review,
                  title: 'Reviews',
                  onTap: () {
                    Navigator.pushNamed(context, '/reviews');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context,
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.green,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
