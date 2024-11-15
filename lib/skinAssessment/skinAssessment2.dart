import 'package:flutter/material.dart';
import 'package:ingreskin/skinAssessment/skinAssessment3.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SkinTextureScreen(),
    );
  }
}

class SkinTextureScreen extends StatefulWidget {
  @override
  _SkinTextureScreenState createState() => _SkinTextureScreenState();
}

class _SkinTextureScreenState extends State<SkinTextureScreen> {
  String? _selectedSkinTexture;

  void _onNext() {
    if (_selectedSkinTexture == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a skin texture before proceeding.")),
      );
      return;
    }
    // Navigate to the SkinTypeScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SkinTypeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Skin Assessment',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Indicator
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: 0.5, // Assume 50% completion for this step
                    backgroundColor: Colors.grey[300],
                    color: Colors.teal,
                  ),
                ),
                SizedBox(width: 10),
                Text("Step 2 of 4"),
              ],
            ),
            Divider(color: Colors.grey),
            SizedBox(height: 16),

            // Question
            Text(
              'What is your skin texture, Karthik?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'This helps us know the moisture content in your skin.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 16),

            // Options
            buildSkinTextureOption(
              title: 'Oily',
              description: 'Oily',
              imagePath: 'assets/oily.png', // Update with actual image path
              value: 'Oily',
            ),
            buildSkinTextureOption(
              title: 'Dry',
              description: 'Dry',
              imagePath: 'assets/dry.png', // Update with actual image path
              value: 'Dry',
            ),
            buildSkinTextureOption(
              title: 'Combination',
              description: 'Combination',
              imagePath: 'assets/combination.png', // Update with actual image path
              value: 'Combination',
            ),

            // Spacer and Next Button
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for creating skin texture options
  Widget buildSkinTextureOption({
    required String title,
    required String description,
    required String imagePath,
    required String value,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundImage: AssetImage(imagePath),
        radius: 25,
      ),
      title: Text(title),
      subtitle: Text(description),
      trailing: Radio<String>(
        value: value,
        groupValue: _selectedSkinTexture,
        onChanged: (String? newValue) {
          setState(() {
            _selectedSkinTexture = newValue;
          });
        },
      ),
    );
  }
}


