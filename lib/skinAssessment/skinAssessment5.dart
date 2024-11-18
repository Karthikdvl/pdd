import 'package:flutter/material.dart';
import 'package:ingreskin/homeScreenSection/productDetailpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SkinSubConcernScreen(),
    );
  }
}

class SkinSubConcernScreen extends StatefulWidget {
  @override
  _SkinSubConcernScreenState createState() => _SkinSubConcernScreenState();
}

class _SkinSubConcernScreenState extends State<SkinSubConcernScreen> {
  String? _selectedSubConcern;

  void _onGenerateRegime() {
    if (_selectedSubConcern == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an option before proceeding.")),
      );
      return;
    }
    // Navigate to the next screen or perform action
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProductDetailPage(),
      ),
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
                    value: 0.7, // Assume 70% completion
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
              'Which of these describes your sub-concern, Karthik?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Option 1: Acne Scars
            buildSubConcernOption(
              title: 'Acne Scars',
              description: 'Permanent bumpy skin caused by severe acne',
              imagePath:
                  'assets/acne_scars.png', // Update with actual image path
              value: 'Acne Scars',
            ),

            // Option 2: Acne Marks
            buildSubConcernOption(
              title: 'Acne Marks',
              description: 'Temporary marks or spots left after acne',
              imagePath:
                  'assets/acne_marks.png', // Update with actual image path
              value: 'Acne Marks',
            ),

            // Spacer and Generate Regime Button
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onGenerateRegime,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Generate Your Regime',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for creating sub-concern options
  Widget buildSubConcernOption({
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
        groupValue: _selectedSubConcern,
        onChanged: (String? newValue) {
          setState(() {
            _selectedSubConcern = newValue;
          });
        },
      ),
    );
  }
}
