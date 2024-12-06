import 'dart:async';
import 'package:flutter/material.dart';
import 'thankyouforreg.dart';

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VerifyAccountScreen(
          email: "johndoe@gmail.com"), // Replace with actual email
    );
  }
}

class VerifyAccountScreen extends StatefulWidget {
  final String email;

  const VerifyAccountScreen({super.key, required this.email});

  @override
  _VerifyAccountScreenState createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  bool _isButtonEnabled = false;
  int _secondsRemaining = 59;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _isButtonEnabled = false;
    setState(() => _secondsRemaining = 59);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _isButtonEnabled = true;
        timer.cancel();
      }
    });
  }

  void _resendCode() {
    _startTimer();
    // Implement actual resend code logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Verify Account'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Information Text
              Text(
                'Code has been sent to ${widget.email}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20.0),

              // Code Input Field
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Enter Code',
                  hintText: '4 Digit Code',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Code is required';
                  } else if (value.length != 4) {
                    return 'Code must be 4 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Resend Code with Countdown Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Didn\'t receive the code?',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  TextButton(
                    onPressed: _isButtonEnabled ? _resendCode : null,
                    child: Text(
                      _isButtonEnabled
                          ? 'Resend Code'
                          : 'Resend code in 00:${_secondsRemaining.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: _isButtonEnabled ? Colors.blue : Colors.grey,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),

              // Verify Account Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ThankYouPage()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'Verify Account',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
