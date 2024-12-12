import 'package:flutter/material.dart';
import 'package:ingreskin/skinAssesstest/skinpages/page4_skin_concerns.dart';
import 'package:ingreskin/skinAssesstest/userModel/userdatamodel.dart';
 // Import the UserSkinData model

class SkinSensitivityPage extends StatefulWidget {
  final UserSkinData userSkinData; // Accept the UserSkinData instance

  const SkinSensitivityPage({Key? key, required this.userSkinData}) : super(key: key);

  @override
  _SkinSensitivityPageState createState() => _SkinSensitivityPageState();
}

class _SkinSensitivityPageState extends State<SkinSensitivityPage> {
  String? _selectedSensitivity;

  final List<Map<String, String>> sensitivityOptions = [
    {'label': 'Not Sensitive', 'image': 'assets/logo1.png'},
    {'label': 'Mildly Sensitive', 'image': 'assets/logo1.png'},
    {'label': 'Very Sensitive', 'image': 'assets/logo1.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skin Sensitivity'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How sensitive is your skin?', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: sensitivityOptions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSensitivity = sensitivityOptions[index]['label'];
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedSensitivity ==
                                  sensitivityOptions[index]['label']
                              ? Colors.teal
                              : Colors.grey,
                          width: 5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            sensitivityOptions[index]['image']!,
                            height: 60,
                            width: 60,
                          ),
                          SizedBox(width: 10),
                          Text(
                            sensitivityOptions[index]['label']!,
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
                  backgroundColor: Colors.blue, // Set the button color
                ),
                onPressed: () {
                  if (_selectedSensitivity != null) {
                    // Update the UserSkinData object with the selected sensitivity
                    widget.userSkinData.skinSensitivity = _selectedSensitivity;

                    // Navigate to the next page with the updated UserSkinData
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SkinConcernsPage(
                          userSkinData: widget.userSkinData,
                        ),
                      ),
                    );
                  } else {
                    // Show an error if no selection is made
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select your skin sensitivity.')),
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
}
