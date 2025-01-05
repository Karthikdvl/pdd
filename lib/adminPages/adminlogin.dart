// import 'package:flutter/material.dart';
// import 'package:ingreskin/adminPages/adminDashboard.dart';
// import 'package:ingreskin/adminPages/admin_forgot_password.dart';
// import 'package:ingreskin/adminPages/feedbackscreen.dart';
// import 'package:ingreskin/adminPages/productEditscreen.dart';
// import 'package:ingreskin/adminPages/productListScreen.dart';
// import 'package:ingreskin/adminPages/reviewScreen.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:ingreskin/config.dart';
// import 'package:ingreskin/getstartedpage.dart';

// class AdminLoginApp extends StatelessWidget {
//   const AdminLoginApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const AdminLoginScreen(),
//       routes: {
//         '/list-products': (context) => ProductListScreen(),
//         '/feedback': (context) => const FeedbackScreen(),
//         '/reviews': (context) => const ReviewsScreen(),
//         '/dashboard': (context) => const DashboardScreen(),
//         '/forgot-password': (context) => const AdminForgotPasswordScreen(),
//         '/get-started': (context) => GetStartedPage(),
//       },
//     );
//   }
// }

// class AdminLoginScreen extends StatefulWidget {
//   const AdminLoginScreen({Key? key}) : super(key: key);

//   @override
//   _AdminLoginScreenState createState() => _AdminLoginScreenState();
// }

// class _AdminLoginScreenState extends State<AdminLoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false; // Track loading state

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _login() async {
//     if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
//       _showErrorDialog("Please enter both email and password.");
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final response = await http.post(
//         Uri.parse('$BASE_URL/admin/login'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'email': _emailController.text,
//           'password': _passwordController.text,
//         }),
//       );

//       final data = json.decode(response.body);

//       if (response.statusCode == 200 && data['status'] == 'success') {
//         // Navigate to Dashboard directly
//         Navigator.pushReplacementNamed(context, '/dashboard');
//       } else {
//         _showErrorDialog(data['message'] ?? 'Login failed. Please try again.');
//       }
//     } catch (e) {
//       _showErrorDialog('An error occurred. Please check your connection.');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: const Text('Admin Login'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildTextField(
//               controller: _emailController,
//               label: 'Email',
//               obscureText: false,
//             ),
//             const SizedBox(height: 16),
//             _buildTextField(
//               controller: _passwordController,
//               label: 'Password',
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             _isLoading
//                 ? const CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: _login,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       minimumSize: const Size(double.infinity, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                     child: const Text('Login'),
//                   ),
//             const SizedBox(height: 16),
//             TextButton(
//               onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
//               child: const Text('Forgot Password?'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required bool obscureText,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//       ),
//     );
//   }
// }
