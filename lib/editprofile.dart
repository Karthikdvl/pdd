import 'package:flutter/material.dart';
import 'package:ingreskin/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  // Load user details from shared preferences
  Future<void> _loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('userName') ?? '';
    final email = prefs.getString('userEmail') ?? '';

    setState(() {
      _nameController.text = name;
      _email = email;
    });
  }

  // Save profile name
  Future<void> _saveProfileName() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      _showErrorDialog('Name cannot be empty.');
      return;
    }

    try {
      final uri = Uri.parse('$BASE_URL/update-profile-name');
      final response = await http.post(
        uri,
        body: {'email': _email, 'name': name},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success']) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userName', name);
          Navigator.pop(context);
        } else {
          _showErrorDialog(data['message'] ?? 'Failed to update name.');
        }
      } else {
        _showErrorDialog('Failed to update name. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred. Please check your connection.');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveProfileName,
              child: const Text('Save Name'),
            ),
          ],
        ),
      ),
    );
  }
}
