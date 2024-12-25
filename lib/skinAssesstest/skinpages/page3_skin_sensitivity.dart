import 'package:flutter/material.dart';
import 'package:ingreskin/skinAssesstest/skinpages/page4_skin_concerns.dart';
import 'package:ingreskin/skinAssesstest/userModel/userdatamodel.dart'; // Import the correct file

class SkinSensitivityPage extends StatefulWidget {
  final UserSkinData userSkinData;

  const SkinSensitivityPage({Key? key, required this.userSkinData}) : super(key: key);

  @override
  _SkinSensitivityPageState createState() => _SkinSensitivityPageState();
}

class _SkinSensitivityPageState extends State<SkinSensitivityPage> {
  SkinSensitivity? _isSensitive = SkinSensitivity.NotSensitive; // Use the SkinSensitivity enum from userdatamodel.dart

  final List<Map<String, String>> sensitivityOptions = [
    {'label': 'Not Sensitive', 'image': 'assets/logo1.png'},
    {'label': 'Sensitive', 'image': 'assets/logo1.png'},
  ];

  void _updateSensitivity(int index) {
    setState(() {
      _isSensitive = SkinSensitivity.values[index]; // Use the SkinSensitivity enum
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Skin Sensitivity',
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
            Text('How sensitive is your skin?', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: sensitivityOptions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _updateSensitivity(index);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _isSensitive == SkinSensitivity.values[index]
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
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  // Save the sensitivity enum value
                  widget.userSkinData.skinSensitivity = _isSensitive;

                  // Navigate to the next page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SkinConcernsPage(
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
