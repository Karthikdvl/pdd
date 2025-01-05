import 'package:flutter/material.dart';
import 'package:ingreskin/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = 'N/A';
  String _email = 'N/A';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? 'N/A';
      _email = prefs.getString('email') ?? 'N/A';
    });
  }

  Future<void> _logout() async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/logout'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        Navigator.pushReplacementNamed(context, '/get-started');
      } else {
        _showErrorDialog('Failed to logout. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred. Please check your connection.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _navigateTo(String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16), // Space at the top
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context), // Navigate back
                ),
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Divider(thickness: 1),
                  SizedBox(height: 16),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Color(0xFFEDE7F6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: $_name',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email: $_email',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildListItem(
                    icon: Icons.edit,
                    title: 'Edit Profile',
                    onTap: () => _navigateTo('/edit-profile'),
                  ),
                  _buildListItem(
                    icon: Icons.lock,
                    title: 'Change Password',
                    onTap: () => _navigateTo('/reset-password'),
                  ),
                  _buildListItem(
                    icon: Icons.help,
                    title: 'Help',
                    onTap: () => _navigateTo('/help'),
                  ),
                  _buildListItem(
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () => _navigateTo('/settings'),
                  ),
                  _buildListItem(
                    icon: Icons.logout,
                    title: 'Log out',
                    onTap: _logout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFEDE7F6),
        child: Icon(
          icon,
          color: const Color(0xFF6200EA),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}