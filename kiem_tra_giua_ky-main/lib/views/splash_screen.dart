// File: lib/views/splash_screen.dart

import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Chuyển hướng sau 2 giây
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            // Hiệu ứng chuyển trang mượt mà (Fade transition)
            pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple, // Màu chủ đạo
      body: Center(
        // Hiệu ứng Animation kết hợp Scale và Fade
        child: TweenAnimationBuilder(
          duration: const Duration(seconds: 1),
          tween: Tween<double>(begin: 0.5, end: 1.0),
          builder: (context, double scale, child) {
            return Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: scale, // Mờ dần đến rõ
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.article_rounded, size: 100, color: Colors.white),
                    const SizedBox(height: 20),
                    const Text(
                      'TIN TỨC 24H',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Vòng xoay load nhẹ nhàng
                    CircularProgressIndicator(color: Colors.white.withOpacity(0.5)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}