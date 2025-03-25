import 'package:flutter/material.dart';
import 'dart:async';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller setup
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Scale animation for pulsing effect
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Navigate after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/products');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pulsing logo with scaling animation
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Image.asset(
                    'assets/logo.png', 
                    width: 200,
                    height: 200,
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            // Subtle loading indicator
            const CircularProgressIndicator(
              color: Colors.pink,
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            // Loading text with subtle animation
            TweenAnimationBuilder<double>(
              duration: const Duration(seconds: 1),
              tween: Tween(begin: 0, end: 1),
              builder: (context, opacity, child) {
                return Opacity(
                  opacity: opacity,
                  child: Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.pink[300],
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}