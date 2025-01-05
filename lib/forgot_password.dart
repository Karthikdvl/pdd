import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ingreskin/config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2B8761),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF1E293B)),
          bodyMedium: TextStyle(color: Color(0xFF1E293B)),
        ),
        fontFamily: 'Gabarito',
      ),
      home: const ForgotPasswordPage(),
    );
  }
}

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isEmailSent = false;

  @override
  void dispose() {
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendResetInstructions() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        // Simulate API call for email verification
        await Future.delayed(const Duration(seconds: 2));
        print('Sending reset instructions to: ${emailController.text}');
        setState(() {
          _isEmailSent = true;
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to send reset instructions. Please try again.';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

 Future<void> _editPassword() async {
  final newPassword = newPasswordController.text;
  final confirmPassword = confirmPasswordController.text;

  if (newPassword.isEmpty || confirmPassword.isEmpty) {
    setState(() {
      _errorMessage = 'Both fields are required';
    });
    return;
  }

  if (newPassword != confirmPassword) {
    setState(() {
      _errorMessage = 'Passwords do not match';
    });
    return;
  }

  setState(() {
    _isLoading = true;
    _errorMessage = null;
  });

  try {
    const url = '$BASE_URL/api/edit-password'; // API endpoint
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Password updated successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Navigate back to login page
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      final error = jsonDecode(response.body)['message'];
      setState(() {
        _errorMessage = error ?? 'Failed to update password';
      });
    }
  } catch (e) {
    setState(() {
      _errorMessage = 'An error occurred. Please try again.';
    });
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!_isEmailSent) ...[
                    const Text(
                      'Forgot Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value!)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter your email',
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _sendResetInstructions,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text('Send Reset Instructions'),
                    ),
                  ] else ...[
                    const Text(
                      'Set New Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    TextFormField(
                      controller: newPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'New Password',
                        hintText: 'Enter your new password',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        hintText: 'Confirm your new password',
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _editPassword,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text('Update Password'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
