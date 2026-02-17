import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _floatingController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation =
        Tween<double>(begin: 0.75, end: 1).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeOutBack,
    ));

    _pulseAnimation =
        Tween<double>(begin: 1.0, end: 1.06).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    _mainController.forward();

    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  Widget emotionFloatingIcon(
      IconData icon, double top, double left, Color color) {
    return AnimatedBuilder(
      animation: _floatingController,
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.06),
        ),
        child: Icon(icon, size: 30, color: color.withOpacity(0.75)),
      ),
      builder: (context, child) {
        double movement = sin(_floatingController.value * pi * 2) * 10;

        return Positioned(
          top: top + movement,
          left: left,
          child: child!,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E293B),
              Color(0xFF111827),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: ParticlePainter(_floatingController),
              ),
            ),
            emotionFloatingIcon(
              Icons.sentiment_very_satisfied,
              110,
              35,
              Colors.greenAccent,
            ),
            emotionFloatingIcon(
              Icons.sentiment_very_dissatisfied,
              130,
              310,
              Colors.lightBlueAccent,
            ),
            emotionFloatingIcon(
              Icons.psychology_alt,
              600,
              45,
              Colors.white,
            ),
            emotionFloatingIcon(
              Icons.sentiment_neutral,
              620,
              300,
              Colors.brown,
            ),
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: child,
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                            child: Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.15),
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.chat_bubble_outline,
                                  size: 95,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 55),
                      const Text(
                        "IA Emocional",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Classificação Inteligente de Emoções",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(height: 35),
                      const CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final AnimationController controller;

  ParticlePainter(this.controller) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.04);

    for (int i = 0; i < 20; i++) {
      double dx = (i * 90 + controller.value * 140) % size.width;
      double dy = (i * 150 + controller.value * 220) % size.height;

      canvas.drawCircle(
        Offset(dx, dy),
        3 + (i % 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
