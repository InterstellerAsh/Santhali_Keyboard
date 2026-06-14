import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:santhali_keyboard/models/keyboard_settings.dart';
import 'package:santhali_keyboard/theme/keyboard_theme.dart';
import 'package:santhali_keyboard/widgets/santhali_keyboard_widget.dart';

class TypingArenaTab extends StatefulWidget {
  final KeyboardSettings settings;

  const TypingArenaTab({super.key, required this.settings});

  @override
  State<TypingArenaTab> createState() => _TypingArenaTabState();
}

class _TypingArenaTabState extends State<TypingArenaTab> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isKeyboardVisible = true;

  @override
  void initState() {
    super.initState();
    // Keep keyboard visible by default for immediate interaction
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _copyToClipboard() {
    if (_controller.text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _controller.text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Text copied to clipboard!'),
        backgroundColor: KeyboardThemeData.getTheme(widget.settings).primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _clearText() {
    setState(() {
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = KeyboardThemeData.getTheme(widget.settings);
    final textStyle = GoogleFonts.notoSansOlChiki(
      textStyle: TextStyle(
        fontSize: 20,
        color: theme.onSurface,
      ),
    );

    return Scaffold(
      backgroundColor: theme.background,
      body: Column(
        children: [
          // Typing Sandbox area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.surface, theme.background.withOpacity(0.95)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: theme.primary.withOpacity(0.25),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primary.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Toolbar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: theme.primary.withOpacity(0.1),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Typing Area',
                            style: GoogleFonts.beVietnamPro(
                              fontWeight: FontWeight.bold,
                              color: theme.primary,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.copy, color: theme.secondary, size: 20),
                                tooltip: 'Copy Text',
                                onPressed: _controller.text.isEmpty ? null : _copyToClipboard,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                tooltip: 'Clear Text',
                                onPressed: _controller.text.isEmpty ? null : _clearText,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Input Text Area
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isKeyboardVisible = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          color: Colors.transparent,
                          alignment: Alignment.topLeft,
                          child: SingleChildScrollView(
                            child: Text(
                              _controller.text,
                              style: textStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Custom Keyboard Panel
          if (_isKeyboardVisible)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: SanthaliKeyboardWidget(
                controller: _controller,
                settings: widget.settings,
                onEnterPressed: () {
                  // Simulate return
                  final selection = _controller.selection;
                  final currentText = _controller.text;
                  int start = selection.start;
                  int end = selection.end;
                  if (start < 0 || end < 0) {
                    start = currentText.length;
                    end = currentText.length;
                  }
                  final newText = currentText.replaceRange(start, end, '\n');
                  _controller.value = TextEditingValue(
                    text: newText,
                    selection: TextSelection.collapsed(offset: start + 1),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
