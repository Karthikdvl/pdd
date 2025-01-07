import 'package:flutter/material.dart';
import 'package:ingreskin/skinAssesstest/skinpages/page8_sun_exposure.dart';
import 'package:ingreskin/skinAssesstest/userModel/userdatamodel.dart';// Import UserSkinData model

class RoutinePreferencePage extends StatefulWidget {
  final UserSkinData userSkinData; // Accept UserSkinData instance

  const RoutinePreferencePage({Key? key, required this.userSkinData}) : super(key: key);

  @override
  _RoutinePreferencePageState createState() => _RoutinePreferencePageState();
}

class _RoutinePreferencePageState extends State<RoutinePreferencePage> {
  String? _selectedPreference;

  final List<Map<String, String>> routineOptions = [
    {'label': 'Minimal (Quick and Easy)', 'image': 'assets/skinimages/steps.png'},
    {'label': 'Moderate (Few Steps)', 'image': 'assets/skinimages/steps.png'},
    {'label': 'Extensive (Full Routine)', 'image': 'assets/skinimages/steps.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skincare Routine'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What is your skincare routine preference?', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: routineOptions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPreference = routineOptions[index]['label'];
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedPreference == routineOptions[index]['label']
                              ? Colors.teal
                              : Colors.grey,
                          width: 5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            routineOptions[index]['image']!,
                            height: 60,
                            width: 60,
                          ),
                          SizedBox(width: 10),
                          Text(
                            routineOptions[index]['label']!,
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
                  // Update UserSkinData with the selected preference
                  widget.userSkinData.routinePreference = _selectedPreference;

                  // Navigate to SunExposurePage with updated UserSkinData
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SunExposurePage(
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
