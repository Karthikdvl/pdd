import 'package:flutter/material.dart';
import 'package:ingreskin/skinAssesstest/skinpages/page9_primary_environment.dart';
import 'package:ingreskin/skinAssesstest/userModel/userdatamodel.dart';
// Import UserSkinData

class SunExposurePage extends StatefulWidget {
  final UserSkinData userSkinData; // Accept UserSkinData instance

  const SunExposurePage({Key? key, required this.userSkinData})
      : super(key: key);

  @override
  _SunExposurePageState createState() => _SunExposurePageState();
}

class _SunExposurePageState extends State<SunExposurePage> {
  String? _selectedFrequency;

  final List<Map<String, String>> exposureOptions = [
    {
      'label': 'Rarely (Less than 1 hour)',
      'image': 'assets/skinimages/rarely.png'
    },
    {
      'label': 'Occasionally (1-3 hours)',
      'image': 'assets/skinimages/occasionally.png'
    },
    {
      'label': 'Frequently (More than 3 hours)',
      'image': 'assets/skinimages/frequently.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sunlight Exposure'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How often are you exposed to sunlight?',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: exposureOptions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFrequency = exposureOptions[index]['label'];
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedFrequency ==
                                  exposureOptions[index]['label']
                              ? Colors.teal
                              : Colors.grey,
                          width: 5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            exposureOptions[index]['image']!,
                            height: 60,
                            width: 60,
                          ),
                          SizedBox(width: 10),
                          Text(
                            exposureOptions[index]['label']!,
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
                  if (_selectedFrequency == null) {
                    // Show a Snackbar if no sun exposure option is selected
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Please select your sunlight exposure frequency before proceeding.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    // Update UserSkinData with the selected sun exposure frequency
                    widget.userSkinData.sunExposure = _selectedFrequency;

                    // Navigate to PrimaryEnvironmentPage with updated UserSkinData
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrimaryEnvironmentPage(
                          userSkinData: widget.userSkinData,
                        ),
                      ),
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
