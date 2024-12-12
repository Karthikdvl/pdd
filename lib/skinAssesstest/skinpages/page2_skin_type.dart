import 'package:flutter/material.dart';
import 'package:ingreskin/skinAssesstest/skinpages/page3_skin_sensitivity.dart';
import 'package:ingreskin/skinAssesstest/userModel/userdatamodel.dart';

 // Import UserSkinData model

class SkinTypePage extends StatefulWidget {
  final UserSkinData userSkinData; // Accept UserSkinData as a parameter

  const SkinTypePage({Key? key, required this.userSkinData}) : super(key: key);

  @override
  _SkinTypePageState createState() => _SkinTypePageState();
}

class _SkinTypePageState extends State<SkinTypePage> {
  String? _selectedSkinType;

  final List<Map<String, String>> skinTypes = [
    {'type': 'Dry', 'image': 'assets/logo1.png'},
    {'type': 'Oily', 'image': 'assets/logo1.png'},
    {'type': 'Combination', 'image': 'assets/logo1.png'},
    {'type': 'Normal', 'image': 'assets/logo1.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Skin Type',
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
            Text('What is your skin type?', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: skinTypes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSkinType = skinTypes[index]['type'];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedSkinType == skinTypes[index]['type']
                              ? Colors.teal
                              : Colors.grey,
                          width: 5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            skinTypes[index]['image']!,
                            height: 80,
                            width: 80,
                          ),
                          SizedBox(height: 8),
                          Text(
                            skinTypes[index]['type']!,
                            style: TextStyle(
                              color: _selectedSkinType == skinTypes[index]['type']
                                  ? Colors.teal
                                  : Colors.black,
                            ),
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
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  if (_selectedSkinType != null) {
                    // Save the selected skin type into UserSkinData
                    widget.userSkinData.skinType = _selectedSkinType;

                    // Navigate to the next page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SkinSensitivityPage(
                          userSkinData: widget.userSkinData, // Pass the updated UserSkinData
                        ),
                      ),
                    );
                  } else {
                    // Show an error message if no option is selected
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select your skin type.')),
                    );
                  }
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
