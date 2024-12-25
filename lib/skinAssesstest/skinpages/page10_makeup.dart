import 'package:flutter/material.dart';
import 'package:ingreskin/skinAssesstest/skinpages/productRecommentpage.dart';
import 'package:ingreskin/skinAssesstest/skinpages/summarypage.dart';
import 'package:ingreskin/skinAssesstest/userModel/userdatamodel.dart'; // Import RecommendedProductsPage
import 'dart:convert';
import 'package:http/http.dart' as http;

class MakeupPage extends StatefulWidget {
  final UserSkinData userSkinData; // Accept UserSkinData instance

  const MakeupPage({Key? key, required this.userSkinData}) : super(key: key);

  @override
  _MakeupPageState createState() => _MakeupPageState();
}

class _MakeupPageState extends State<MakeupPage> {
  String? _selectedAnswer;

  final List<Map<String, String>> makeupOptions = [
    {'label': 'Yes', 'image': 'assets/logo1.png'},
    {'label': 'No', 'image': 'assets/logo1.png'},
    {'label': 'Occasionally', 'image': 'assets/logo1.png'},
  ];

  void _handleOptionSelection(String label) {
    setState(() {
      _selectedAnswer = label;
    });
  }

  void _onFinish() async {
    if (_selectedAnswer == null) {
      // Show a message if no option is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an option before proceeding.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Update UserSkinData with the selected makeup preference
    widget.userSkinData.wearsMakeup = _selectedAnswer;

    // Debugging or optional log
    print('Makeup Preference: ${widget.userSkinData.wearsMakeup}');

    // Send the data to Python backend for recommendations
    await sendUserDataToPython(
      widget.userSkinData.skinTypeSelections!, // Pass skinTypeSelections map
      widget.userSkinData.skinSensitivity!.index,   // Convert SkinSensitivity enum to int (0 or 1)
    );
  }

  // Function to send user data to Python backend and get recommendations
 Future<void> sendUserDataToPython(Map<String, int> skinTypeSelections, int skinSensitivity) async {
  final url = Uri.parse('http://192.168.73.146:5000/recommend'); // Python server URL
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({
    'skinTypeSelections': skinTypeSelections,  // Send the Map<String, int>
    'skinSensitivity': skinSensitivity,        // Send the skinSensitivity (int: 0 or 1)
  });

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final recommendations = responseData['recommendations'];

      print('Recommendations: $recommendations');
      
      // Navigate to RecommendedProductsPage with recommendations
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecommendedProductsPage(recommendations: recommendations),  // Pass recommendations
        ),
      );
    } else {
      print('Failed to fetch recommendations: ${response.statusCode} ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to fetch recommendations. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    print('Error fetching recommendations: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('An error occurred. Please check your connection.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Makeup Routine'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Do you wear makeup regularly?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: makeupOptions.length,
                itemBuilder: (context, index) {
                  final option = makeupOptions[index];
                  return GestureDetector(
                    onTap: () => _handleOptionSelection(option['label']!),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedAnswer == option['label']
                              ? Colors.teal
                              : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            option['image']!,
                            height: 60,
                            width: 60,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            option['label']!,
                            style: const TextStyle(fontSize: 16),
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
                onPressed: _onFinish,
                child: const Text('Finish'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
