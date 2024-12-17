// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// void main() {
//   runApp(MyApp());
// }


// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: BarcodeScannerScreen(),
//     );
//   }
// }

// class BarcodeScannerScreen extends StatefulWidget {
//   @override
//   _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
// }

// class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
//   final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? _controller;
//   String? _barcodeResult;

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   // Toggle scanning state when "Start Scan" is pressed
//   void _startScan() {
//     setState(() {
//       _barcodeResult = null; // Clear previous scan result
//     });
//     _controller?.resumeCamera(); // Start/resume the camera
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Barcode Scanner',
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context); // Back button action
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Barcode Placeholder
//             Container(
//               height: 200,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey, width: 2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Center(
//                 child: _barcodeResult == null
//                     ? Text(
//                         'Sample Barcode Placeholder',
//                         style: TextStyle(color: Colors.grey),
//                       )
//                     : Text(
//                         'Scanned Barcode: $_barcodeResult',
//                         style: TextStyle(fontSize: 16, color: Colors.black),
//                       ),
//               ),
//             ),
//             SizedBox(height: 24),

//             // "Start Scan" Button
//             ElevatedButton(
//               onPressed: _startScan,
//               child: Text('Start Scan'),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: Colors.blue,
//                 padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//             ),
//             SizedBox(height: 24),

//             // Barcode Scanner View
//             Expanded(
//               child: QRView(
//                 key: _qrKey,
//                 onQRViewCreated: _onQRViewCreated,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this._controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         _barcodeResult = scanData.code; // Capture the scanned barcode
//         controller.pauseCamera(); // Pause scanning after a result is found
//       });
//     });
//   }
// }
