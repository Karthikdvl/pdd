  // import 'package:flutter/material.dart';
  // import 'package:http/http.dart' as http;
  // import 'package:ingreskin/thankyouforreg.dart';
  // import 'dart:convert'; // For JSON encoding and decoding
  // // import 'verify_acc.dart';

  // void main() {
  //   runApp(const MyApp());
  // }

  // class MyApp extends StatelessWidget {
  //   const MyApp({super.key});

  //   @override
  //   Widget build(BuildContext context) {
  //     return const MaterialApp(
  //       debugShowCheckedModeBanner: false,
  //       home: RegisterScreen(),
  //     );
  //   }
  // }

  // class RegisterScreen extends StatefulWidget {
  //   const RegisterScreen({super.key});

  //   @override
  //   State<RegisterScreen> createState() => _RegisterScreenState();
  // }

  // class _RegisterScreenState extends State<RegisterScreen> {
  //   final _formKey = GlobalKey<FormState>();
  //   final TextEditingController _nameController = TextEditingController();
  //   final TextEditingController _emailController = TextEditingController();
  //   final TextEditingController _passwordController = TextEditingController();
  //   final TextEditingController _confirmPasswordController =
  //   TextEditingController();

  //   bool _showPassword = false;
  //   bool _showConfirmPassword = false;

  //   @override
  //   void dispose() {
  //     _nameController.dispose();
  //     _emailController.dispose();
  //     _passwordController.dispose();
  //     _confirmPasswordController.dispose();
  //     super.dispose();
  //   }

  //   void _togglePasswordVisibility() {
  //     setState(() {
  //       _showPassword = !_showPassword;
  //     });
  //   }

  //   void _toggleConfirmPasswordVisibility() {
  //     setState(() {
  //       _showConfirmPassword = !_showConfirmPassword;
  //     });
  //   }

  //   Future<void> _registerUser() async {
  //     final String apiUrl = 'http://192.168.211.146:5000/register'; // Replace with your Flask backend URL

  //     final Map<String, dynamic> requestData = {
  //       'name': _nameController.text,
  //       'email': _emailController.text,
  //       'password': _passwordController.text,
  //       'confirm_password': _confirmPasswordController.text,
  //     };

  //     try {
  //       final response = await http.post(
  //         Uri.parse(apiUrl),
  //         headers: {'Content-Type': 'application/json'},
  //         body: jsonEncode(requestData),
  //       );

  //       if (response.statusCode == 201) {
  //         // Successful registration
  //         final Map<String, dynamic> responseBody = jsonDecode(response.body);
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text(responseBody['message'])),
  //         );

  //         // Navigate to the Verify Account screen
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => ThankYouPage(
  //               // email: _emailController.text,
  //             ),
  //           ),
  //         );
  //       } else {
  //         // Handle errors from the backend
  //         final Map<String, dynamic> responseBody = jsonDecode(response.body);
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text(responseBody['message'])),
  //         );
  //       }
  //     } catch (error) {
  //       // Handle network errors
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('An error occurred: $error')),
  //       );
  //     }
  //   }

  //   @override
  //   Widget build(BuildContext context) {
  //     return Scaffold(
  //       appBar: AppBar(
  //         leading: IconButton(
  //           icon: const Icon(Icons.arrow_back),
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ),
  //         title: const Text('Register'),
  //         centerTitle: true,
  //       ),
  //       body: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Form(
  //           key: _formKey,
  //           child: ListView(
  //             children: [
  //               // Name Field
  //               TextFormField(
  //                 controller: _nameController,
  //                 decoration: const InputDecoration(
  //                   labelText: 'Name',
  //                 ),
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'Name is required';
  //                   }
  //                   return null;
  //                 },
  //               ),
  //               const SizedBox(height: 16.0),

  //               // Email Field
  //               TextFormField(
  //                 controller: _emailController,
  //                 decoration: const InputDecoration(
  //                   labelText: 'E-mail',
  //                   hintText: 'Enter your email',
  //                 ),
  //                 keyboardType: TextInputType.emailAddress,
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'E-mail is required';
  //                   } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
  //                     return 'Enter a valid email address';
  //                   }
  //                   return null;
  //                 },
  //               ),
  //               const SizedBox(height: 16.0),

  //               // Password Field
  //               TextFormField(
  //                 controller: _passwordController,
  //                 decoration: InputDecoration(
  //                   labelText: 'Password',
  //                   suffixIcon: IconButton(
  //                     icon: Icon(
  //                       _showPassword ? Icons.visibility : Icons.visibility_off,
  //                     ),
  //                     onPressed: _togglePasswordVisibility,
  //                   ),
  //                 ),
  //                 obscureText: !_showPassword,
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'Password is required';
  //                   } else if (value.length < 8) {
  //                     return 'Password must contain 8 characters';
  //                   }
  //                   return null;
  //                 },
  //               ),
  //               const SizedBox(height: 16.0),

  //               // Confirm Password Field
  //               TextFormField(
  //                 controller: _confirmPasswordController,
  //                 decoration: InputDecoration(
  //                   labelText: 'Confirm Password',
  //                   suffixIcon: IconButton(
  //                     icon: Icon(
  //                       _showConfirmPassword
  //                           ? Icons.visibility
  //                           : Icons.visibility_off,
  //                     ),
  //                     onPressed: _toggleConfirmPasswordVisibility,
  //                   ),
  //                 ),
  //                 obscureText: !_showConfirmPassword,
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return 'Please confirm your password';
  //                   } else if (value != _passwordController.text) {
  //                     return 'Passwords do not match';
  //                   }
  //                   return null;
  //                 },
  //               ),
  //               const SizedBox(height: 32.0),

  //               // Create Account Button
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: ElevatedButton(
  //                   onPressed: () {
  //                     if (_formKey.currentState?.validate() ?? false) {
  //                       _registerUser(); // Call the register API
  //                     }
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: const Color.fromARGB(255, 88, 220, 92),
  //                     padding: const EdgeInsets.symmetric(vertical: 16.0),
  //                   ),
  //                   child: const Text(
  //                     'Create Account',
  //                     style: TextStyle(
  //                       fontSize: 18.0,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  // }
