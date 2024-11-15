import 'package:flutter/material.dart';

import 'skinAssessment5.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SkinConcernScreen(),
    );
  }
}

class SkinConcernScreen extends StatefulWidget {
  @override
  _SkinConcernScreenState createState() => _SkinConcernScreenState();
}

class _SkinConcernScreenState extends State<SkinConcernScreen> {
  String? _selectedConcern;

  void _onNext() {
    if (_selectedConcern == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a skin concern before proceeding.")),
      );
      return;
    }
    // Navigate to the next screen or perform the next action
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SkinSubConcernScreen()),
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
              'Which of these describes your concern, Karthik?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Options
            Expanded(
              child: ListView(
                children: [
                  buildSkinConcernOption(
                    title: 'Acne',
                    description: 'Permanent bumpy skin caused by severe acne',
                    imagePath: 'assets/logo1.png',
                    value: 'Acne',
                  ),
                  buildSkinConcernOption(
                    title: 'Open Pores',
                    description: 'Large open pores on the skin surface',
                    imagePath: 'assets/logo1.png',
                    value: 'Open Pores',
                  ),
                  buildSkinConcernOption(
                    title: 'Pigmentation',
                    description: 'Uneven skin tone with dark patches',
                    imagePath: 'assets/logo1.png',
                    value: 'Pigmentation',
                  ),
                  buildSkinConcernOption(
                    title: 'Dark Circles',
                    description: 'Dark shadows under the eyes',
                    imagePath: 'assets/logo1.png',
                    value: 'Dark Circles',
                  ),
                  buildSkinConcernOption(
                    title: 'Acne Marks & Scars',
                    description: 'Marks or scars left after acne',
                    imagePath: 'assets/logo1.png',
                    value: 'Acne Marks & Scars',
                  ),
                ],
              ),
            ),

            // Next Button
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

  // Helper widget for creating skin concern options
  Widget buildSkinConcernOption({
    required String title,
    required String description,
    required String imagePath,
    required String value,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8),
      leading: Image.asset(
        imagePath,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(description),
      trailing: Radio<String>(
        value: value,
        groupValue: _selectedConcern,
        onChanged: (String? newValue) {
          setState(() {
            _selectedConcern = newValue;
          });
        },
      ),
    );
  }
}
