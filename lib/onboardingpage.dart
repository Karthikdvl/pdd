// lib/onboarding_page.dart

import 'package:flutter/material.dart';
import 'package:ingreskin/adminPages/adminlogin.dart';
import 'package:ingreskin/login1.dart';
import 'package:ingreskin/register.dart';

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingPage(),
    );
  }
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  // Methods for handling button presses
  // void _onAdminLoginPressed() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => AdminLoginScreen()),
  //   );
  // }

  void _onLoginPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _onSignUpPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 24,
                  left: 44,
                  right: 44,
                  child: Container(
                    width: double.infinity,
                    height: 424,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/onboardimage.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //   left: 37,
                //   top: 421,
                //   child: ElevatedButton(
                //     onPressed: _onAdminLoginPressed,
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Color(0xFF4AA6F2),
                //       fixedSize: Size(340, 55),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(20),
                //       ),
                //     ),
                //     child: const Text(
                //       'Admin login',
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 24,
                //         fontFamily: 'Inter',
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //   ),
                // ),
                Positioned(
                  left: 37,
                  top: 490,
                  child: Container(
                    width: 340,
                    height: 2,
                    color: const Color.fromARGB(255, 22, 22, 22),
                  ),
                ),
                Positioned(
                  left: 37,
                  top: 620,
                  child: ElevatedButton(
                    onPressed: _onLoginPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2B8761),
                      fixedSize: Size(340, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 37,
                  top: 720,
                  child: ElevatedButton(
                    onPressed: _onSignUpPressed,
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(width: 2, color: Color(0xFF2D4890)),
                      backgroundColor: Colors.white,
                      fixedSize: Size(340, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xFF2D4890),
                        fontSize: 24,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Create AdminLoginPage, LoginPage, and SignUpPage classes

// class AdminLoginPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Admin Login')),
//       body: Center(child: Text('Admin Login Page')),
//     );
//   }
// }

// class LoginPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Center(child: Text('Login Page')),
//     );
//   }
// }

// class SignUpPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Sign Up')),
//       body: Center(child: Text('Sign Up Page')),
//     );
//   }
// }
