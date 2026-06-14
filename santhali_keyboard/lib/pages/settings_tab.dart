import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:santhali_keyboard/models/keyboard_settings.dart';
import 'package:santhali_keyboard/theme/keyboard_theme.dart';

class SettingsTab extends StatefulWidget {
  final KeyboardSettings settings;

  const SettingsTab({super.key, required this.settings});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> with WidgetsBindingObserver {
  static const _channel = MethodChannel('com.kherwal.santhali_keyboard/settings');

  bool _isKeyboardEnabled = false;
  bool _isKeyboardSelected = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkKeyboardStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkKeyboardStatus();
    }
  }

  Future<void> _checkKeyboardStatus() async {
    try {
      final bool enabled = await _channel.invokeMethod<bool>('isKeyboardEnabled') ?? false;
      final bool selected = await _channel.invokeMethod<bool>('isKeyboardSelected') ?? false;
      if (mounted) {
        setState(() {
          _isKeyboardEnabled = enabled;
          _isKeyboardSelected = selected;
        });
      }
    } catch (_) {}
  }

  Future<void> _enableKeyboard() async {
    try {
      await _channel.invokeMethod('openInputSettings');
    } catch (_) {}
  }

  Future<void> _selectKeyboard() async {
    try {
      await _channel.invokeMethod('showKeyboardPicker');
    } catch (_) {}
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required KeyboardThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.primary.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.secondary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: theme.secondary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: theme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 11,
                    color: theme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: theme.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = KeyboardThemeData.getTheme(widget.settings);

    return Scaffold(
      backgroundColor: theme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customization Hub Hero Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: theme.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: theme.primary.withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    bottom: -20,
                    child: Icon(
                      Icons.settings_outlined,
                      size: 100,
                      color: theme.onPrimary.withOpacity(0.15),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customization Hub',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: theme.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tailor your Ol Chiki typing experience to your personal style and workflow.',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 13,
                          color: theme.onPrimary.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // SYSTEM ACTIVATION SECTION
            Text(
              'KEYBOARD ACTIVATION',
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: theme.onSurface.withOpacity(0.5),
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: theme.primary.withOpacity(0.12), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: theme.primary.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isKeyboardSelected ? Icons.check_circle : Icons.error_outline,
                        color: _isKeyboardSelected ? Colors.green : theme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _isKeyboardSelected 
                              ? 'Chiki Keyboard is Active!' 
                              : 'Keyboard Setup Pending',
                          style: GoogleFonts.beVietnamPro(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: theme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Step 1: Enable
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isKeyboardEnabled ? Colors.green.withOpacity(0.15) : theme.primary.withOpacity(0.15),
                        ),
                        child: Center(
                          child: Icon(
                            _isKeyboardEnabled ? Icons.check : Icons.looks_one,
                            color: _isKeyboardEnabled ? Colors.green : theme.primary,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Step 1: Enable in Settings',
                              style: GoogleFonts.beVietnamPro(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: theme.onSurface,
                              ),
                            ),
                            Text(
                              'Turn on Chiki Keyboard in language settings.',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 11,
                                color: theme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!_isKeyboardEnabled)
                        ElevatedButton(
                          onPressed: _enableKeyboard,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primary,
                            foregroundColor: theme.onPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            'Enable',
                            style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        )
                      else
                        const Icon(Icons.done, color: Colors.green),
                    ],
                  ),
                  const Divider(height: 24),

                  // Step 2: Choose/Select
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isKeyboardSelected ? Colors.green.withOpacity(0.15) : theme.primary.withOpacity(0.15),
                        ),
                        child: Center(
                          child: Icon(
                            _isKeyboardSelected ? Icons.check : Icons.looks_two,
                            color: _isKeyboardSelected ? Colors.green : theme.primary,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Step 2: Choose Input Method',
                              style: GoogleFonts.beVietnamPro(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: theme.onSurface,
                              ),
                            ),
                            Text(
                              'Set Chiki Keyboard as your default keyboard.',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 11,
                                color: theme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_isKeyboardEnabled && !_isKeyboardSelected)
                        ElevatedButton(
                          onPressed: _selectKeyboard,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primary,
                            foregroundColor: theme.onPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            'Select',
                            style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        )
                      else if (_isKeyboardSelected)
                        const Icon(Icons.done, color: Colors.green)
                      else
                        ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            'Select',
                            style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // General Section Header
            Text(
              'GENERAL PREFERENCES',
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: theme.onSurface.withOpacity(0.5),
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),

            // Switches list
            _buildSwitchRow(
              icon: Icons.vibration,
              title: 'Haptic Feedback',
              subtitle: 'Vibrate on keypress',
              value: widget.settings.hapticFeedback,
              onChanged: (val) => setState(() => widget.settings.setHapticFeedback(val)),
              theme: theme,
            ),
            const SizedBox(height: 12),
            
            _buildSwitchRow(
              icon: Icons.spellcheck,
              title: 'Auto-correct',
              subtitle: 'Correct words while typing',
              value: widget.settings.autoCorrect,
              onChanged: (val) => setState(() => widget.settings.setAutoCorrect(val)),
              theme: theme,
            ),
            const SizedBox(height: 12),

            _buildSwitchRow(
              icon: Icons.volume_up,
              title: 'Sound on Keypress',
              subtitle: 'Audible feedback during typing',
              value: widget.settings.soundOnKeypress,
              onChanged: (val) => setState(() => widget.settings.setSoundOnKeypress(val)),
              theme: theme,
            ),
            const SizedBox(height: 24),

            // Keyboard Height Adjuster
            Text(
              'KEYBOARD HEIGHT',
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: theme.onSurface.withOpacity(0.5),
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.primary.withOpacity(0.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Keyboard Dimension',
                        style: GoogleFonts.beVietnamPro(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: theme.onSurface,
                        ),
                      ),
                      Text(
                        '${widget.settings.keyboardHeight.toInt()} px',
                        style: GoogleFonts.beVietnamPro(
                          fontWeight: FontWeight.bold,
                          color: theme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    min: 220.0,
                    max: 340.0,
                    value: widget.settings.keyboardHeight,
                    activeColor: theme.primary,
                    inactiveColor: theme.primary.withOpacity(0.2),
                    onChanged: (val) => setState(() => widget.settings.setKeyboardHeight(val)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Privacy Card Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: theme.secondaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: theme.secondary.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.security, color: theme.onPrimary, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        'Privacy & Security',
                        style: GoogleFonts.beVietnamPro(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: theme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We never collect your personal keystrokes. Learn how we keep your Ol Chiki data private and secure on-device.',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      color: theme.onPrimary.withOpacity(0.85),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: theme.secondary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      'View Policy',
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Privacy Policy'),
                            content: const Text(
                              'The Santhali Keyboard App values your privacy. '
                              'This input method operates 100% on-device. We do not transmit, '
                              'log, or share your keystrokes, personal details, or vocabulary dictionary '
                              'to any external server. All customized settings are stored locally in the secure storage '
                              'of your terminal device.',
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Close'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
