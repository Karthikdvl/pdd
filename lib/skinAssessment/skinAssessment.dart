import 'package:flutter/material.dart';

import 'skinAssessment2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SkinAssessmentScreen(),
    );
  }
}

class SkinAssessmentScreen extends StatefulWidget {
  @override
  _SkinAssessmentScreenState createState() => _SkinAssessmentScreenState();
}

class _SkinAssessmentScreenState extends State<SkinAssessmentScreen> {
  final TextEditingController _nameController = TextEditingController();
  int? _selectedAgeGroup;
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Skin Assessment 1',
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
            Text('What Is Your Name?', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter Your Name',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 24),
            Text('What Is Your Age?', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                buildAgeButton(0, '<12'),
                buildAgeButton(1, '12-18'),
                buildAgeButton(2, '18-25'),
                buildAgeButton(3, '26-35'),
                buildAgeButton(4, '36-45'),
                buildAgeButton(5, '46-55'),
                buildAgeButton(6, '55+'),
              ],
            ),
            SizedBox(height: 24),
            Text('What Is Your Gender?', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildGenderButton('Male'),
                buildGenderButton('Female'),
              ],
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to SkinTextureScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SkinTextureScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Next →',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for Age Group Buttons
  Widget buildAgeButton(int index, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedAgeGroup == index,
      onSelected: (selected) {
        setState(() {
          _selectedAgeGroup = selected ? index : null;
        });
      },
      selectedColor: Colors.teal,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: _selectedAgeGroup == index ? Colors.white : Colors.black,
      ),
    );
  }

  // Helper method for Gender Buttons
  Widget buildGenderButton(String gender) {
    return ChoiceChip(
      label: Text(gender),
      selected: _selectedGender == gender,
      onSelected: (selected) {
        setState(() {
          _selectedGender = selected ? gender : null;
        });
      },
      selectedColor: Colors.teal,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: _selectedGender == gender ? Colors.white : Colors.black,
      ),
    );
  }
}

