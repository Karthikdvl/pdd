import 'package:flutter/material.dart';
import 'package:ingreskin/skinAssesstest/skinpages/page5_prone_conditions.dart';
import 'package:ingreskin/skinAssesstest/userModel/userdatamodel.dart';// Import UserSkinData model

class SkinConcernsPage extends StatefulWidget {
  final UserSkinData userSkinData; // Accept UserSkinData instance

  const SkinConcernsPage({Key? key, required this.userSkinData}) : super(key: key);

  @override
  _SkinConcernsPageState createState() => _SkinConcernsPageState();
}

class _SkinConcernsPageState extends State<SkinConcernsPage> {
  final List<Map<String, String>> skinConcerns = [
    {'label': 'Acne', 'image': 'assets/skinimages/acneskin.png'},
    {'label': 'Dryness', 'image': 'assets/skinimages/dry.png'},
    {'label': 'Wrinkles', 'image': 'assets/skinimages/wrinkles.png'},
    {'label': 'Dark Spots', 'image': 'assets/skinimages/darkspots.png'},
    //{'label': 'Sensitivity', 'image': 'assets/logo1.png'},
  ];

  List<String> selectedConcerns = [];

  void toggleSelection(String concern) {
    setState(() {
      if (selectedConcerns.contains(concern)) {
        selectedConcerns.remove(concern);
      } else {
        selectedConcerns.add(concern);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skin Concerns'),
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
              'What are your primary skin concerns? (Select all that apply)',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: skinConcerns.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      toggleSelection(skinConcerns[index]['label']!);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: selectedConcerns.contains(skinConcerns[index]['label'])
                              ? Colors.teal
                              : Colors.grey,
                          width: 5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            skinConcerns[index]['image']!,
                            height: 60,
                            width: 60,
                          ),
                          SizedBox(width: 10),
                          Text(
                            skinConcerns[index]['label']!,
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
                  // Update the UserSkinData with selected concerns
                  widget.userSkinData.skinConcerns = selectedConcerns;

                  // Navigate to the next page, passing the updated UserSkinData
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProneConditionsPage(
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
