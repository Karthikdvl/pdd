import 'package:flutter/material.dart';
import 'package:ingreskin/skinAssesstest/skinpages/page7_routine_preference.dart';
import 'package:ingreskin/skinAssesstest/userModel/userdatamodel.dart';
 // Import UserSkinData model

class AllergiesPage extends StatefulWidget {
  final UserSkinData userSkinData; // Accept UserSkinData instance

  const AllergiesPage({Key? key, required this.userSkinData}) : super(key: key);

  @override
  _AllergiesPageState createState() => _AllergiesPageState();
}

class _AllergiesPageState extends State<AllergiesPage> {
  final TextEditingController _allergiesController = TextEditingController();

  @override
  void dispose() {
    _allergiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Allergies'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Do you have any known allergies to skincare ingredients?',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _allergiesController,
              decoration: InputDecoration(
                hintText: 'Enter allergies or leave blank',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Set the text color here
                ),
                onPressed: () {
                  // Update UserSkinData with the allergies input
                  widget.userSkinData.allergies = _allergiesController.text;

                  // Navigate to RoutinePreferencePage with updated UserSkinData
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoutinePreferencePage(
                        userSkinData: widget.userSkinData,
                      ),
                    ),
                  );
                },
                child: Text('Next →'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
