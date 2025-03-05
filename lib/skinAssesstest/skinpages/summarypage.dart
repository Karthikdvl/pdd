// import 'package:flutter/material.dart';
// import 'package:ingreskin/skinAssesstest/userModel/userdatamodel.dart'; // Import your model

// class SummaryPage extends StatelessWidget {
//   final UserSkinData userSkinData; // Accept UserSkinData

//   const SummaryPage({Key? key, required this.userSkinData}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Summary'),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Skin Type: ${userSkinData.skinType ?? "Not Provided"}'),
//             SizedBox(height: 10),
//             Text('Makeup Preference: ${userSkinData.wearsMakeup ?? "Not Provided"}'),
//             SizedBox(height: 10),
//             Text('Allergies: ${userSkinData.allergies ?? "Not Provided"}'),
//             SizedBox(height: 10),
//             Text('Sun Exposure: ${userSkinData.sunExposure ?? "Not Provided"}'),
//             SizedBox(height: 10),
//             Text('Primary Environment: ${userSkinData.primaryEnvironment ?? "Not Provided"}'),
//             SizedBox(height: 10),
//             Text('Routine Preference: ${userSkinData.routinePreference ?? "Not Provided"}'),
//             SizedBox(height: 10),
//             Text('Age Group: ${userSkinData.ageGroup ?? "Not Provided"}'),
//             SizedBox(height: 10),
//             Text('Skin Concerns: ${userSkinData.skinConcerns ?? "Not Provided"}'),
//             SizedBox(height: 10),
//             Text('Makeup Routine: ${userSkinData.wearsMakeup ?? "Not Provided"}'),
//             SizedBox(height: 10),
//             Text('skin Type Selections: ${userSkinData.skinTypeSelections ?? "Not Provided"}'),
//             SizedBox(height: 10),
//             Text('skin Sensitivity: ${userSkinData.skinSensitivity ?? "Not Provided"}'),
//             SizedBox(height: 10),
//             // You can add more fields here if necessary
//           ],
//         ),
//       ),
//     );
//   }
// }
