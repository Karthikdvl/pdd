import 'package:flutter/material.dart';
import 'package:ingreskin/skinAssesstest/skinpages/page6_allergies.dart';
import 'package:ingreskin/skinAssesstest/userModel/userdatamodel.dart';
 // Import UserSkinData model

class ProneConditionsPage extends StatefulWidget {
  final UserSkinData userSkinData; // Accept UserSkinData instance

  const ProneConditionsPage({Key? key, required this.userSkinData}) : super(key: key);

  @override
  _ProneConditionsPageState createState() => _ProneConditionsPageState();
}

class _ProneConditionsPageState extends State<ProneConditionsPage> {
  List<String> _selectedConditions = [];

  final List<Map<String, String>> proneOptions = [
    {'label': 'Acne Scars', 'image': 'assets/skinimages/acnescars.png'},
    {'label': 'Redness', 'image': 'assets/skinimages/sensitive.png'},
    {'label': 'Dry Patches', 'image': 'assets/skinimages/dry.png'},
    {'label': 'Dark Pathces', 'image': 'assets/skinimages/darkpatches.png'},
    {'label': 'Oily Skin', 'image': 'assets/skinimages/oilyface.png'},
  ];

  void toggleCondition(String condition) {
    setState(() {
      if (_selectedConditions.contains(condition)) {
        _selectedConditions.remove(condition);
      } else {
        _selectedConditions.add(condition);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prone Conditions'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you prone to any of the following?', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: proneOptions.length,
                itemBuilder: (context, index) {
                  final condition = proneOptions[index];
                  return GestureDetector(
                    onTap: () {
                      toggleCondition(condition['label']!);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedConditions.contains(condition['label'])
                              ? Colors.teal
                              : Colors.grey,
                          width: 5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            condition['image']!,
                            height: 60,
                            width: 60,
                          ),
                          SizedBox(width: 10),
                          Text(
                            condition['label']!,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Set the text color here
                ),
                onPressed: () {
                  // Update UserSkinData with selected prone conditions
                  widget.userSkinData.proneConditions = _selectedConditions;

                  // Navigate to AllergiesPage with updated UserSkinData
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllergiesPage(
                        userSkinData: widget.userSkinData,
                      ),
                    ),
                  );
                },
                child: Text('Next →'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
