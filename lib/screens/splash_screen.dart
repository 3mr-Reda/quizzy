import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/lightbulb_icon.dart';
import '../widgets/rocket_illustration.dart';
import 'home_screen.dart';

export '../widgets/lightbulb_icon.dart';
export '../widgets/rocket_illustration.dart';

typedef Splash = SplashScreen;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    // Configure system overlays for transparent status bar with dark icons
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFFEDF1F9),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeController.forward();

    // Auto-navigate to HomeScreen after 2.8s
    _navTimer = Timer(const Duration(milliseconds: 2800), _navigateToHome);
  }

  void _navigateToHome() {
    if (!mounted) return;
    _navTimer?.cancel();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Exact background color from the design
    const backgroundColor = Color(0xFFEDF1F9);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: GestureDetector(
        onTap: _navigateToHome,
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        children: [
                          const Spacer(flex: 3),
                          // 1. App Header: Glowing Lightbulb Icon + Quizzy + Subtitle
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const LightbulbIcon(size: 32),
                              const SizedBox(height: 8),
                              Text(
                                'Quizzy',
                                style: GoogleFonts.poppins(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF222E50),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Test Your Knowledge',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF7585A2),
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),

                          const Spacer(flex: 2),
                          // 2. Center Illustration: Animated Rocket taking off from clouds
                          const Flexible(
                            flex: 8,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: RocketIllustration(
                                width: 320,
                                height: 340,
                              ),
                            ),
                          ),
                          const Spacer(flex: 3),

                          // 3. Bottom iOS Home Indicator bar
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Container(
                              width: 135,
                              height: 5,
                              decoration: BoxDecoration(
                                color: const Color(0xFFC7D0E0),
                                borderRadius: BorderRadius.circular(2.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
