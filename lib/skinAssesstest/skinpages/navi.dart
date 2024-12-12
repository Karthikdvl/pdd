import 'package:flutter/material.dart';

class NavigationBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
        title: Text(
          'Navigation',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Row(
        children: [
          // Navigation Bar
          NavigationBar(),
          // Default content when nothing is selected
          Expanded(
            child: Center(
              child: Text(
                'Select an option from the menu',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Information Section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/logo1.png'), // Replace with your image path
                ),
                SizedBox(height: 10),
                Text(
                  'User Name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'user@example.com',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Divider(),
          // Navigation Buttons
          buildMenuButton(context, Icons.home, 'Home', '/home'),
          buildMenuButton(context, Icons.health_and_safety, 'Skin Assessment', '/skin-assessment'),
        ],
      ),
    );
  }

  // Helper method to build navigation buttons
  Widget buildMenuButton(BuildContext context, IconData icon, String label, String routeName) {
    return TextButton.icon(
      onPressed: () {
        if (routeName == '/') {
          Navigator.popUntil(context, (route) => route.isFirst); // Navigate to HomePage
        } else {
          Navigator.of(context).pushNamed(routeName); // Navigate to specified route
        }
      },
      icon: Icon(icon, color: Colors.grey[800]),
      label: Text(
        label,
        style: TextStyle(color: Colors.black),
      ),
      style: ButtonStyle(
        alignment: Alignment.centerLeft,
        padding: WidgetStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }
}
