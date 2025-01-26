import 'package:flutter/material.dart';
import 'package:ingreskin/skinAssesstest/userModel/userdatamodel.dart';
import 'page2_skin_type.dart';

// Main application
class SkinAssessmentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create an instance of the UserSkinData model
    UserSkinData userSkinData = UserSkinData();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PersonalDetailsPage(userSkinData: userSkinData),
    );
  }
}

// Personal Details Page
class PersonalDetailsPage extends StatefulWidget {
  final UserSkinData userSkinData; // Accept UserSkinData as a parameter

  const PersonalDetailsPage({Key? key, required this.userSkinData}) : super(key: key);

  @override
  _PersonalDetailsPageState createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  int? _selectedAgeGroup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personal Details',
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
            // Age Group Selection
            Text('What is your age group?', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  buildAgeButton(0, '<12'),
                  buildAgeButton(1, '12–18'),
                  buildAgeButton(2, '18–25'),
                  buildAgeButton(3, '26–35'),
                  buildAgeButton(4, '36–45'),
                  buildAgeButton(5, '46–55'),
                  buildAgeButton(6, '55+'),
                ],
              ),
            ),
            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  if (_selectedAgeGroup == null) {
                    // Show a Snackbar if no age group is selected
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please select an age group before proceeding.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    // Save the data into the UserSkinData instance
                    widget.userSkinData.name = _nameController.text;
                    widget.userSkinData.ageGroup = _selectedAgeGroup;

                    // Navigate to the next page and pass the same UserSkinData instance
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SkinTypePage(userSkinData: widget.userSkinData),
                      ),
                    );
                  }
                },
                child: Text('Next →'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAgeButton(int index, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedAgeGroup == index ? Colors.teal : Colors.grey[200],
            foregroundColor: _selectedAgeGroup == index ? Colors.white : Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          onPressed: () {
            setState(() {
              _selectedAgeGroup = index;
            });
          },
          child: Text(label, style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
