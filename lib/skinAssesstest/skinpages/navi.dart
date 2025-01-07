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
      body: NavigationBar(),
    );
  }
}

class NavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildMenuButton(
              context,
              Icons.home,
              'Home',
              '/home',
            ),
            SizedBox(height: 20), // Space between buttons
            buildMenuButton(
              context,
              Icons.health_and_safety,
              'Skin Assessment',
              '/skin-assessment',
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build navigation buttons
  Widget buildMenuButton(BuildContext context, IconData icon, String label, String routeName) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.purple[50],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.purple),
      ),
      title: Text(label, style: TextStyle(color: Colors.black, fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: () {
        Navigator.of(context).pushNamed(routeName);
      },
    );
  }
}
