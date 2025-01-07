import 'package:flutter/material.dart';
import 'package:ingreskin/skinAssesstest/skinpages/page10_makeup.dart';
import 'package:ingreskin/skinAssesstest/userModel/userdatamodel.dart'; // Import UserSkinData

class PrimaryEnvironmentPage extends StatefulWidget {
  final UserSkinData userSkinData; // Accept UserSkinData instance

  const PrimaryEnvironmentPage({Key? key, required this.userSkinData}) : super(key: key);

  @override
  _PrimaryEnvironmentPageState createState() => _PrimaryEnvironmentPageState();
}

class _PrimaryEnvironmentPageState extends State<PrimaryEnvironmentPage> {
  String? _selectedEnvironment;

  final List<Map<String, String>> environmentOptions = [
    {'label': 'Urban', 'image': 'assets/skinimages/urban.png'},
    {'label': 'Rural', 'image': 'assets/skinimages/rural.png'},
    {'label': 'Coastal', 'image': 'assets/skinimages/costal.png'},
    {'label': 'Mountainous', 'image': 'assets/skinimages/mountain.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Primary Environment'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What is your primary environment?', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: environmentOptions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedEnvironment = environmentOptions[index]['label'];
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedEnvironment == environmentOptions[index]['label']
                              ? Colors.teal
                              : Colors.grey,
                          width: 5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            environmentOptions[index]['image']!,
                            height: 60,
                            width: 60,
                          ),
                          SizedBox(width: 10),
                          Text(
                            environmentOptions[index]['label']!,
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
                  // Update UserSkinData with the selected primary environment
                  widget.userSkinData.primaryEnvironment = _selectedEnvironment;

                  // Navigate to MakeupPage with updated UserSkinData
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MakeupPage(
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
