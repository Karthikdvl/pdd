import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchAnimation(),
    );
  }
}

class SearchAnimation extends StatefulWidget {
  const SearchAnimation({super.key});

  @override
  State<SearchAnimation> createState() => _SearchAnimationState();
}

class _SearchAnimationState extends State<SearchAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.scale(
              scale: _animation.value,
              child: const Icon(
                Icons.search,
                size: 60,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Finding similar results...',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}