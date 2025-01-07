import 'package:flutter/material.dart';
import 'package:ingreskin/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  File? _selectedImage;
  String _email = '';
  String _photoUrl = ''; // Add a variable to store the photo URL
  bool _isPickingImage = false;

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
    final photoUrl = prefs.getString('photoUrl') ?? ''; // Load photo URL

    setState(() {
      _nameController.text = name;
      _email = email;
      _photoUrl = photoUrl; // Set the photo URL
    });
  }

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    if (_isPickingImage) return;
    setState(() {
      _isPickingImage = true;
    });

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to pick image. Please try again.');
    } finally {
      setState(() {
        _isPickingImage = false;
      });
    }
  }

  // Save profile photo
  Future<void> _saveProfilePhoto() async {
    if (_selectedImage == null) {
      _showErrorDialog('Please select an image.');
      return;
    }

    try {
      final uri = Uri.parse('$BASE_URL/update-profile-photo');
      final request = http.MultipartRequest('POST', uri);
      request.fields['email'] = _email;

      request.files.add(await http.MultipartFile.fromPath(
        'photo',
        _selectedImage!.path,
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = json.decode(responseBody);

        if (data['success']) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('photoUrl', data['photoUrl']);
          setState(() {
            _photoUrl = data['photoUrl']; // Update the photoUrl state
          });
          Navigator.pop(context);
        } else {
          _showErrorDialog(data['message'] ?? 'Failed to update photo.');
        }
      } else {
        _showErrorDialog('Failed to update photo. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred. Please check your connection.');
    }
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
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: _selectedImage != null
                    ? FileImage(_selectedImage!) // If an image is selected, use FileImage
                    : (_photoUrl.isNotEmpty ? NetworkImage(_photoUrl) as ImageProvider<Object>? : null), // If no image selected, but a URL exists, use NetworkImage
                child: _selectedImage == null && _photoUrl.isEmpty
                    ? const Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveProfilePhoto,
              child: const Text('Save Photo'),
            ),
            const SizedBox(height: 16),
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
