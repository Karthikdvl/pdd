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
            buildSkinAssessmentButton(context),
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

  // Custom Skin Assessment button
  Widget buildSkinAssessmentButton(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/skin-assessment');
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.touch_app, color: Colors.white), // Added icon
              SizedBox(width: 8),
              Text(
                'Skin Assessment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
