import 'package:flutter/material.dart';
import 'package:ingreskin/skinAssesstest/skinpages/page3_skin_sensitivity.dart';
import 'package:ingreskin/skinAssesstest/userModel/userdatamodel.dart';

class SkinTypePage extends StatefulWidget {
  final UserSkinData userSkinData; // Accept UserSkinData as a parameter

  const SkinTypePage({Key? key, required this.userSkinData}) : super(key: key);

  @override
  _SkinTypePageState createState() => _SkinTypePageState();
}

class _SkinTypePageState extends State<SkinTypePage> {
  Map<String, int> _skinTypeSelections = {
    'Dry': 0,
    'Oily': 0,
    'Combination': 0,
    'Normal': 0,
  };

  void _toggleSelection(String type) {
    setState(() {
      // Count currently selected types
      int selectedCount = _skinTypeSelections.values.where((value) => value == 1).length;

      // Allow selection of up to 2 types
      if (_skinTypeSelections[type] == 1) {
        // If already selected, deselect
        _skinTypeSelections[type] = 0;
      } else if (selectedCount < 1) {
        // Select if fewer than 2 types are selected
        _skinTypeSelections[type] = 1;
      } else {
        // Show an error if the user tries to select more than 2
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You can select only one skin types.')),
        );
      }
    });
  }

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
            //Text('select any two:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _skinTypeSelections.keys.length,
                itemBuilder: (context, index) {
                  String skinType = _skinTypeSelections.keys.elementAt(index);
                  return GestureDetector(
                    onTap: () => _toggleSelection(skinType),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _skinTypeSelections[skinType] == 1
                              ? Colors.teal
                              : Colors.grey,
                          width: 5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logo1.png',
                            height: 80,
                            width: 80,
                          ),
                          SizedBox(height: 8),
                          Text(
                            skinType,
                            style: TextStyle(
                              color: _skinTypeSelections[skinType] == 1
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
                  // Check if at least one skin type is selected
                  if (_skinTypeSelections.values.contains(1)) {
                    // Save the selected skin types into UserSkinData
                    widget.userSkinData.skinTypeSelections = Map.from(_skinTypeSelections);

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
                    // Show an error message if no options are selected
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select at least one skin type.')),
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
