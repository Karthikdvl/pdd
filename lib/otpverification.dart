import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ingreskin/config.dart';
import 'package:ingreskin/thankyouforreg.dart';
class OTPScreen extends StatefulWidget {
  final String email;
  final String name;
  final String password;

  OTPScreen({
    required this.email,
    required this.name,
    required this.password,
  });

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  String message = "";
Future<void> verifyOtpAndRegister() async {
  setState(() {
    isLoading = true;
    message = "";
  });

  final otpApiUrl = '$BASE_URL/verify-otp';
  final registerApiUrl = '$BASE_URL/register';

  try {
    // Verify OTP
    final otpResponse = await http.post(
      Uri.parse(otpApiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': widget.email,
        'otp': otpController.text,
        'name': widget.name,
        'password': widget.password,
      }),
    );

    if (otpResponse.statusCode == 200) {
      // OTP is verified, now register the user
      final registerResponse = await http.post(
        Uri.parse(registerApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': widget.name,
          'email': widget.email,
          'password': widget.password,
          'confirm_password': widget.password, // Assuming the password is being confirmed in the same way
        }),
      );

      if (registerResponse.statusCode == 201) {
        // Registration successful, navigate to Thank You Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ThankYouPage(),
          ),
        );
      } else {
        final responseBody = jsonDecode(registerResponse.body);
        setState(() {
          message = responseBody['message'] ?? 'Registration failed.';
        });
      }
    } else {
      final responseBody = jsonDecode(otpResponse.body);
      setState(() {
        message = responseBody['message'] ?? 'OTP verification failed.';
      });
    }
  } catch (error) {
    setState(() {
      message = 'An error occurred: $error';
    });
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OTP Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter the OTP sent to ${widget.email}'),
            SizedBox(height: 20),
            TextField(
              controller: otpController,
              decoration: InputDecoration(labelText: 'Enter OTP'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            if (isLoading) CircularProgressIndicator(),
            if (!isLoading)
              ElevatedButton(
                onPressed: verifyOtpAndRegister,
                child: Text('Verify OTP'),
              ),
            if (message.isNotEmpty)
              Text(
                message,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

