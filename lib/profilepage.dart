import 'package:flutter/material.dart';
import 'package:ingreskin/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = 'N/A';
  String _email = 'N/A';
  String _photoUrl = ''; // Placeholder for photo URL

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  // Load user details from shared preferences
  Future<void> _loadUserDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('userName') ?? 'N/A';
      final email = prefs.getString('userEmail') ?? 'N/A';

      setState(() {
        _name = name;
        _email = email;
      });

      // Fetch the profile photo URL based on email
      await _fetchProfilePhotoUrl(_email);
    } catch (e) {
      _showErrorDialog('Failed to load user details. Please try again.');
    }
  }

  // Fetch the profile photo URL from the server based on email
  Future<void> _fetchProfilePhotoUrl(String email) async {
    try {
      final uri = Uri.parse('$BASE_URL/get-profile-photo?email=$email');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        setState(() {
          // If the response is a URL (not base64 data), use it directly
          _photoUrl = response.body;  // Assuming the server returns a URL (image path)
        });
      } else {
        // If not found, fallback to the default photo
        setState(() {
          _photoUrl = '$BASE_URL/uploads/default.jpg'; // Fallback to default photo URL
        });
      }
    } catch (e) {
      _showErrorDialog('An error occurred. Please try again.');
    }
  }

  // Show error dialog
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

  // Logout function
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
            const SizedBox(height: 16),
            // Profile Section with Updated Background Color
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 116, 177, 247),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                  top: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _photoUrl.isNotEmpty
                        ? NetworkImage(_photoUrl)  // Use NetworkImage with the URL
                        : null, // Use the photoUrl fetched from the server
                    child: _photoUrl.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      _name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Changed text color to white
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      _email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white, // Changed text color to white
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildListItem(
                    icon: Icons.edit,
                    title: 'Edit Profile',
                    onTap: () => Navigator.pushNamed(context, '/edit-profile'),
                  ),
                  _buildListItem(
                    icon: Icons.lock,
                    title: 'Change Password',
                    onTap: () => Navigator.pushNamed(context, '/reset-password'),
                  ),
                ],
              ),
            ),
            // Log out button at the bottom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 249, 83, 83), // Light red color
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(double.infinity, 50), // Full width and taller height
                ),
                onPressed: _logout,
                child: const Text(
                  'Log out',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Space at the bottom
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
