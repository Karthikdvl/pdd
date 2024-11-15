import 'package:flutter/material.dart';

import 'skinAssessment4.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SkinTypeScreen(),
    );
  }
}

class SkinTypeScreen extends StatefulWidget {
  @override
  _SkinTypeScreenState createState() => _SkinTypeScreenState();
}

class _SkinTypeScreenState extends State<SkinTypeScreen> {
  String? _selectedSkinType;

  void _onNext() {
    if (_selectedSkinType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a skin type before proceeding.")),
      );
      return;
    }
    // Navigate to the SkinConcernScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SkinConcernScreen()),
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
                    value: 0.75, // Assume 75% completion for this step
                    backgroundColor: Colors.grey[300],
                    color: Colors.teal,
                  ),
                ),
                SizedBox(width: 10),
                Text("Step 3 of 4"),
              ],
            ),
            Divider(color: Colors.grey),
            SizedBox(height: 16),

            // Question
            Text(
              'What is your skin type, Karthik?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'This helps us with the right ingredients for your skin.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 16),

            // Options
            buildSkinTypeOption(
              title: 'Normal',
              value: 'Normal',
            ),
            buildSkinTypeOption(
              title: 'Sensitive',
              value: 'Sensitive',
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

  // Helper widget for creating skin type options
  Widget buildSkinTypeOption({
    required String title,
    required String value,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: Radio<String>(
        value: value,
        groupValue: _selectedSkinType,
        onChanged: (String? newValue) {
          setState(() {
            _selectedSkinType = newValue;
          });
        },
      ),
    );
  }
}


