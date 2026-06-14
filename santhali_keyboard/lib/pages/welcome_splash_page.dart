import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:santhali_keyboard/models/keyboard_settings.dart';
import 'package:santhali_keyboard/theme/keyboard_theme.dart';
import 'package:santhali_keyboard/main.dart';

class WelcomeSplashPage extends StatefulWidget {
  final KeyboardSettings settings;

  const WelcomeSplashPage({super.key, required this.settings});

  @override
  State<WelcomeSplashPage> createState() => _WelcomeSplashPageState();
}

class _WelcomeSplashPageState extends State<WelcomeSplashPage>
    with TickerProviderStateMixin {
  // Main animation controller for entrance (staggered)
  late final AnimationController _entranceController;
  
  // Looping animation controller for background blobs
  late final AnimationController _blobController;
  
  // Looping animation controller for button pulse
  late final AnimationController _pulseController;

  // Staggered Animations
  late final Animation<double> _backgroundFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _joharTextFade;
  late final Animation<double> _joharTextSlide;
  late final Animation<double> _olChikiTextFade;
  late final Animation<double> _olChikiTextSlide;
  late final Animation<double> _dividerWidth;
  late final Animation<double> _subTextFade;
  late final Animation<double> _buttonFade;
  late final Animation<double> _buttonSlide;

  // Loop Animations
  late final Animation<double> _blobAnimation;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Entrance Controller Setup (2.2 seconds total duration)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // 2. Blob Controller Setup (8 seconds loop, back and forth)
    _blobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    // 3. Pulse Controller Setup (1.6 seconds loop, back and forth)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // Define Staggered Animations
    _backgroundFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
      ),
    );

    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.15, 0.55, curve: Curves.elasticOut),
      ),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.15, 0.45, curve: Curves.easeOut),
      ),
    );

    _joharTextFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
      ),
    );

    _joharTextSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    _olChikiTextFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.45, 0.75, curve: Curves.easeOut),
      ),
    );

    _olChikiTextSlide = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.45, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _dividerWidth = Tween<double>(begin: 0.0, end: 80.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.55, 0.85, curve: Curves.easeInOutBack),
      ),
    );

    _subTextFade = Tween<double>(begin: 0.0, end: 0.75).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
      ),
    );

    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
      ),
    );

    _buttonSlide = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.75, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // Loop Animations
    _blobAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _blobController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start entrance animation after the first frame is rendered to prevent layout flicker
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _entranceController.forward().then((_) {
          // Start button pulse when entrance completes
          if (mounted) {
            _pulseController.repeat(reverse: true);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _blobController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _navigateToMainShell() {
    // Elegant slide up transition to main screen
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            KeyboardMainShell(settings: widget.settings),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.08);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var slideTween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          
          var fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(
            CurveTween(curve: Curves.easeIn),
          );

          return FadeTransition(
            opacity: animation.drive(fadeTween),
            child: SlideTransition(
              position: animation.drive(slideTween),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = KeyboardThemeData.getTheme(widget.settings);

    return Scaffold(
      backgroundColor: theme.background,
      body: AnimatedBuilder(
        animation: Listenable.merge([_entranceController, _blobController]),
        builder: (context, child) {
          // Calculate moving positions for background blobs
          final blobOffset1 = Offset(
            40 * math.sin(_blobAnimation.value),
            20 * math.cos(_blobAnimation.value),
          );
          final blobOffset2 = Offset(
            -30 * math.cos(_blobAnimation.value),
            30 * math.sin(_blobAnimation.value),
          );

          final double screenHeight = MediaQuery.of(context).size.height;
          final bool isSmallScreen = screenHeight < 720;
          
          final double logoSize = isSmallScreen ? 120.0 : 170.0;
          final double spacing32 = isSmallScreen ? 16.0 : 32.0;
          final double spacing16 = isSmallScreen ? 10.0 : 16.0;
          final double title1Size = isSmallScreen ? 30.0 : 38.0;
          final double title2Size = isSmallScreen ? 24.0 : 32.0;
          final double subtitleSize = isSmallScreen ? 12.0 : 14.0;

          return FadeTransition(
            opacity: _backgroundFade,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: theme.backgroundGradient,
              ),
              child: Stack(
                children: [
                  // Decorative Ambient Blob 1 (Top Left)
                  Positioned(
                    top: -100 + blobOffset1.dy,
                    left: -100 + blobOffset1.dx,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.primary.withOpacity(0.08),
                      ),
                    ),
                  ),

                  // Decorative Ambient Blob 2 (Bottom Right)
                  Positioned(
                    bottom: -120 + blobOffset2.dy,
                    right: -120 + blobOffset2.dx,
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.secondary.withOpacity(0.06),
                      ),
                    ),
                  ),

                  // Main Content
                  SafeArea(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Spacer(flex: 3),

                            // Folded Hands Image Container
                            FadeTransition(
                              opacity: _logoFade,
                              child: ScaleTransition(
                                scale: _logoScale,
                                child: Container(
                                  width: logoSize,
                                  height: logoSize,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme.surface,
                                    border: Border.all(
                                      color: theme.primary.withOpacity(0.2),
                                      width: 2.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.primary.withOpacity(0.12),
                                        blurRadius: 24,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Image.asset(
                                        'assets/images/johar_hands.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            SizedBox(height: spacing32),

                            // Greeting texts
                            Transform.translate(
                              offset: Offset(0, _joharTextSlide.value),
                              child: FadeTransition(
                                opacity: _joharTextFade,
                                child: Text(
                                  'Ol Chiki',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: title1Size,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                    color: theme.primary,
                                  ),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 4),

                            Transform.translate(
                              offset: Offset(0, _olChikiTextSlide.value),
                              child: FadeTransition(
                                opacity: _olChikiTextFade,
                                child: ShaderMask(
                                  shaderCallback: (bounds) => theme.secondaryGradient.createShader(
                                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                                  ),
                                  child: Text(
                                    'ᱚᱞ ᱪᱤᱠᱤ',
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: title2Size,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: spacing16),

                            // Elegant Divider Line
                            FadeTransition(
                              opacity: _subTextFade,
                              child: Container(
                                width: _dividerWidth.value,
                                height: 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: theme.primaryGradient,
                                ),
                              ),
                            ),

                            SizedBox(height: spacing16),

                            // Keyboard Name Text
                            FadeTransition(
                              opacity: _subTextFade,
                              child: Text(
                                'CHIKI KEYBOARD',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: subtitleSize,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 4.5,
                                  color: theme.onSurface.withOpacity(0.65),
                                ),
                              ),
                            ),

                            const Spacer(flex: 3),

                            // Let's Start Button
                            Transform.translate(
                              offset: Offset(0, _buttonSlide.value),
                              child: FadeTransition(
                                opacity: _buttonFade,
                                child: ScaleTransition(
                                  scale: _pulseAnimation,
                                  child: InkWell(
                                    onTap: _navigateToMainShell,
                                    borderRadius: BorderRadius.circular(30),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        gradient: theme.primaryGradient,
                                        boxShadow: [
                                          BoxShadow(
                                            color: theme.primary.withOpacity(0.35),
                                            blurRadius: 16,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isSmallScreen ? 24.0 : 36.0,
                                        vertical: isSmallScreen ? 12.0 : 16.0,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Let's Start",
                                            style: GoogleFonts.beVietnamPro(
                                              fontSize: isSmallScreen ? 14.0 : 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: theme.onPrimary,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(
                                            Icons.east_rounded,
                                            color: theme.onPrimary,
                                            size: isSmallScreen ? 18.0 : 20.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const Spacer(flex: 1),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
