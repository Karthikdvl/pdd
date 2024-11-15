import 'package:flutter/material.dart';
import 'package:ingreskin/skinAssessment/skinAssessment.dart';

void main() {
  runApp( MyApp());
}
class NavigationBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Navigation', style: TextStyle(color: Colors.black)),
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
                '',
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
          // User Information
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/logo1.png'),
                ),
                SizedBox(height: 10),
                Text(
                  'User Name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Divider(),
          // Navigation buttons
          buildMenuButton(context, Icons.home, 'Home', '/'),
          buildMenuButton(context, Icons.health_and_safety, 'Skin Assessment', '/skin-assessment'),
        ],
      ),
    );
  }

  // Helper method to build menu button with navigation
  Widget buildMenuButton(BuildContext context, IconData icon, String label, String routeName) {
    return TextButton.icon(
      onPressed: () {
        if (routeName == '/') {
          Navigator.pop(context); // Return to HomePage
        } else {
          Navigator.of(context).pushNamed(routeName);
        }
      },
      icon: Icon(icon, color: Colors.grey),
      label: Text(label, style: TextStyle(color: Colors.black)),
      style: ButtonStyle(
        alignment: Alignment.centerLeft,
        padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 16, horizontal: 16)),
      ),
    );
  }
}

// Additional screens for demonstration

