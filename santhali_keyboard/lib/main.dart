import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:santhali_keyboard/models/keyboard_settings.dart';
import 'package:santhali_keyboard/pages/settings_tab.dart';
import 'package:santhali_keyboard/pages/themes_tab.dart';
import 'package:santhali_keyboard/pages/typing_arena_tab.dart';
import 'package:santhali_keyboard/pages/welcome_splash_page.dart';
import 'package:santhali_keyboard/theme/keyboard_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SanthaliKeyboardApp());
}

class SanthaliKeyboardApp extends StatefulWidget {
  const SanthaliKeyboardApp({super.key});

  @override
  State<SanthaliKeyboardApp> createState() => _SanthaliKeyboardAppState();
}

class _SanthaliKeyboardAppState extends State<SanthaliKeyboardApp> {
  final KeyboardSettings _settings = KeyboardSettings();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _settings,
      builder: (context, _) {
        final theme = KeyboardThemeData.getTheme(_settings);
        
        return MaterialApp(
          title: 'Ol Chiki Keyboard',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: theme.primary,
              primary: theme.primary,
              secondary: theme.secondary,
              surface: theme.background,
            ),
            textTheme: GoogleFonts.beVietnamProTextTheme(),
          ),
          home: WelcomeSplashPage(settings: _settings),
        );
      },
    );
  }
}

class KeyboardMainShell extends StatefulWidget {
  final KeyboardSettings settings;

  const KeyboardMainShell({super.key, required this.settings});

  @override
  State<KeyboardMainShell> createState() => _KeyboardMainShellState();
}

class _KeyboardMainShellState extends State<KeyboardMainShell> {
  int _currentIndex = 0;

  Widget _buildNavBarItem(int index, IconData outlineIcon, IconData filledIcon, String label, KeyboardThemeData theme) {
    final bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected ? theme.primaryGradient : null,
            borderRadius: BorderRadius.circular(100),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: theme.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? filledIcon : outlineIcon,
                color: isSelected ? theme.onPrimary : theme.onSurface.withOpacity(0.6),
                size: 22,
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: theme.onPrimary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = KeyboardThemeData.getTheme(widget.settings);
    
    final List<Widget> tabs = [
      TypingArenaTab(settings: widget.settings),
      ThemesTab(settings: widget.settings),
      SettingsTab(settings: widget.settings),
    ];

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            color: theme.primary.withOpacity(0.06),
            height: 4,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            icon: Icon(Icons.grid_view_outlined, color: theme.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Welcome to the Ol Chiki Customization Hub!', style: GoogleFonts.beVietnamPro()),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: theme.primary,
                ),
              );
            },
          ),
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => theme.primaryGradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            'Ol Chiki',
            style: GoogleFonts.beVietnamPro(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.primary.withOpacity(0.25), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: theme.primary.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
                image: const DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: tabs,
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 8),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: theme.surface.withOpacity(0.92),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: theme.primary.withOpacity(0.12),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavBarItem(0, Icons.keyboard_outlined, Icons.keyboard, 'Keyboard', theme),
                _buildNavBarItem(1, Icons.palette_outlined, Icons.palette, 'Themes', theme),
                _buildNavBarItem(2, Icons.settings_outlined, Icons.settings, 'Settings', theme),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
