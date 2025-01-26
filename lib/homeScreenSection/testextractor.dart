import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ingreskin/config.dart';
import 'package:ingreskin/homeScreenSection/analysisPage.dart';

class TextExtractorScreen extends StatefulWidget {
  const TextExtractorScreen({super.key});

  @override
  State<TextExtractorScreen> createState() => _TextExtractorScreenState();
}

class _TextExtractorScreenState extends State<TextExtractorScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  String? extractedText;
  Map<String, dynamic>? analysisResult;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

Future<void> _uploadImage() async {
  if (_image == null) return;

  setState(() {
    isLoading = true;
  });

  String? filePath;

  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$BASE_URL/upload'),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        _image!.path,
      ),
    );

    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    var jsonResponse = json.decode(responseData);

    if (response.statusCode == 200) {
      filePath = jsonResponse['file_path'];
      extractedText = jsonResponse['extracted_text'];

      // Automatically analyze the ingredients after extraction
      await _analyzeIngredients(extractedText!, filePath);
    } else {
      _showErrorSnackBar(jsonResponse['error'] ?? 'Failed to upload image');
    }
  } catch (e) {
    _showErrorSnackBar('Error during image upload: $e');
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

Future<void> _analyzeIngredients(String ingredientsText, String? filePath) async {
  if (filePath == null) {
    _showErrorSnackBar('File path is missing. Analysis cannot proceed.');
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    final response = await http.post(
      Uri.parse('$BASE_URL/analyze'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'ingredients': ingredientsText.split(',').map((e) => e.trim()).toList(),
        'file_path': filePath,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        analysisResult = json.decode(response.body);
      });

      // Navigate to the analysis screen
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnalysisPage(result: analysisResult!),
        ),
      );

      // Delete file after returning from analysis page
      await _deleteFile(filePath);
    } else {
      final errorResponse = json.decode(response.body);
      _showErrorSnackBar(errorResponse['error'] ?? 'Failed to analyze ingredients');
    }
  } catch (e) {
    _showErrorSnackBar('Error during analysis: $e');
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

Future<void> _deleteFile(String filePath) async {
  try {
    final response = await http.post(
      Uri.parse('$BASE_URL/delete'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'file_path': filePath}),
    );

    if (response.statusCode != 200) {
      _showErrorSnackBar('Failed to delete file. Please try again later.');
    }
  } catch (e) {
    _showErrorSnackBar('Error deleting file: $e');
  }
}

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Ingredient Extractor',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Upload Section
              const Text(
                'Upload Photos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              // Image Preview
              GestureDetector(
                onTap: () => _showImageSourceDialog(),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _image == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              size: 48,
                              color: Colors.blue.shade300,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Tap to upload or take a photo',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),

              // Note
              const SizedBox(height: 8),
              const Text(
                'Note: Crop the image or take a photo of the ingredient list only.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              // Bottom Buttons
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Help Centre',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      const SizedBox(width: 16),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: isLoading ? null : _uploadImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text('Extract & Analyze'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
