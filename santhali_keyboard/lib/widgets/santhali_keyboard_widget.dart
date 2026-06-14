import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:santhali_keyboard/models/keyboard_settings.dart';
import 'package:santhali_keyboard/theme/keyboard_theme.dart';
import 'package:santhali_keyboard/widgets/key_preview.dart';
import 'package:santhali_keyboard/widgets/sohrai_divider.dart';

enum KeyboardLayoutMode { olChiki, english, symbols }

class SanthaliKeyboardWidget extends StatefulWidget {
  final TextEditingController controller;
  final KeyboardSettings settings;
  final VoidCallback? onEnterPressed;
  final Function(String)? onSuggestionSelected;

  const SanthaliKeyboardWidget({
    super.key,
    required this.controller,
    required this.settings,
    this.onEnterPressed,
    this.onSuggestionSelected,
  });

  @override
  State<SanthaliKeyboardWidget> createState() => _SanthaliKeyboardWidgetState();
}

class _SanthaliKeyboardWidgetState extends State<SanthaliKeyboardWidget> {
  KeyboardLayoutMode _layoutMode = KeyboardLayoutMode.olChiki;
  bool _isShiftActive = false;
  String? _activePreviewChar;
  int? _activePreviewIndex;
  int? _pressedKeyIndex;
  
  // Custom suggestion word list for autocomplete simulation
  final List<String> _santhaliSuggestions = [
    'ᱡᱚᱦᱟᱨ', 'ᱥᱟᱱᱛᱟᱲ', 'ᱚᱞ ᱪᱤᱠᱤ', 'ᱜᱩᱨᱩ ᱜᱚᱢᱠᱮ', 'ᱨᱟᱹᱜᱷᱩᱱᱟᱛᱷ', 'ᱢᱩᱨᱢᱩ', 'ᱥᱟᱱᱛᱟᱲᱤ', 'ᱦᱮᱨᱮᱞ'
  ];
  final List<String> _englishSuggestions = [
    'Johar', 'Santali', 'Ol Chiki', 'Hello', 'Welcome', 'Keyboard', 'Flutter', 'App'
  ];

  void _triggerFeedback() {
    if (widget.settings.hapticFeedback) {
      HapticFeedback.lightImpact();
    }
    if (widget.settings.soundOnKeypress) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  void _insertText(String text) {
    _triggerFeedback();
    final currentText = widget.controller.text;
    final selection = widget.controller.selection;
    
    int start = selection.start;
    int end = selection.end;
    
    if (start < 0 || end < 0) {
      start = currentText.length;
      end = currentText.length;
    }
    
    final newText = currentText.replaceRange(start, end, text);
    widget.controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + text.length),
    );
  }

  void _deleteText() {
    _triggerFeedback();
    final currentText = widget.controller.text;
    final selection = widget.controller.selection;
    
    int start = selection.start;
    int end = selection.end;
    
    if (start < 0 || end < 0) {
      start = currentText.length;
      end = currentText.length;
    }
    
    if (start == 0 && end == 0) return;
    
    String newText;
    int newOffset;
    
    if (start != end) {
      newText = currentText.replaceRange(start, end, '');
      newOffset = start;
    } else {
      // Find the character boundary before the cursor position
      final charBefore = currentText.characters.takeLast(currentText.substring(0, start).characters.length - 1);
      newOffset = charBefore.toString().length;
      newText = currentText.substring(0, newOffset) + currentText.substring(start);
    }
    
    widget.controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }

  List<List<String>> _getLayoutKeys() {
    switch (_layoutMode) {
      case KeyboardLayoutMode.olChiki:
        return [
          ['ᱚ', 'ᱛ', 'ᱜ', 'ᱝ', 'ᱞ', 'ᱟ', 'ᱠ', 'ᱡ', 'ᱢ', 'ᱣ'],
          ['ᱤ', 'ᱥ', 'ᱦ', 'ᱧ', 'ᱨ', 'ᱩ', 'ᱪ', 'ᱫ', 'ᱬ', 'ᱭ'],
          ['ᱮ', 'ᱯ', 'ᱰ', 'ᱱ', 'ᱲ', 'ᱳ', 'ᱴ', 'ᱵ', 'ᱶ', 'ᱷ']
        ];
      case KeyboardLayoutMode.english:
        final qwerty = [
          ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
          ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
          ['z', 'x', 'c', 'v', 'b', 'n', 'm']
        ];
        if (_isShiftActive) {
          return qwerty.map((row) => row.map((char) => char.toUpperCase()).toList()).toList();
        }
        return qwerty;
      case KeyboardLayoutMode.symbols:
        return [
          ['᱐', '᱑', '᱒', '᱓', '᱔', '᱕', '᱖', '᱗', '᱘', '᱙'],
          ['ᱸ', 'ᱹ', 'ᱺ', 'ᱻ', 'ᱼ', 'ᱽ', '᱾', '᱿', ',', '.'],
          ['!', '?', '@', '#', '\$', '%', '&', '*', '(', ')']
        ];
    }
  }

  Widget _buildSuggestionBar(KeyboardThemeData theme) {
    final suggestions = _layoutMode == KeyboardLayoutMode.olChiki ? _santhaliSuggestions : _englishSuggestions;
    return Container(
      height: 48,
      color: theme.background,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final word = suggestions[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
            child: InkWell(
              onTap: () {
                _triggerFeedback();
                if (widget.onSuggestionSelected != null) {
                  widget.onSuggestionSelected!(word);
                } else {
                  // Standard behavior: replace last word or append
                  _insertText('$word ');
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.primary.withOpacity(0.15)),
                ),
                alignment: Alignment.center,
                child: Text(
                  word,
                  style: GoogleFonts.notoSansOlChiki(
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.primary,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildKey({
    required String char,
    required double width,
    required double height,
    required KeyboardThemeData theme,
    required int index,
    bool isFunctional = false,
    Widget? customChild,
    VoidCallback? onTap,
  }) {
    final bool isPressed = _pressedKeyIndex == index;
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _pressedKeyIndex = index;
          if (!isFunctional) {
            _activePreviewChar = char;
            _activePreviewIndex = index;
          }
        });
        _triggerFeedback();
      },
      onTapUp: (_) {
        setState(() {
          _pressedKeyIndex = null;
          _activePreviewChar = null;
          _activePreviewIndex = null;
        });
        if (onTap != null) {
          onTap();
        } else {
          _insertText(char);
        }
      },
      onTapCancel: () {
        setState(() {
          _pressedKeyIndex = null;
          _activePreviewChar = null;
          _activePreviewIndex = null;
        });
      },
      child: AnimatedScale(
        scale: isPressed ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOut,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // The Key Plate itself
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                gradient: isFunctional 
                    ? LinearGradient(
                        colors: [theme.actionKeySurface, theme.actionKeySurface.withOpacity(0.85)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    : theme.keyGradient,
                borderRadius: BorderRadius.circular(8.0),
                border: Border(
                  bottom: BorderSide(
                    color: isFunctional ? theme.onSurface.withOpacity(0.2) : theme.primary.withOpacity(0.25),
                    width: 2.0,
                  ),
                ),
              ),
              alignment: Alignment.center,
              child: customChild ?? Text(
                char,
                style: GoogleFonts.notoSansOlChiki(
                  textStyle: TextStyle(
                    fontSize: _layoutMode == KeyboardLayoutMode.olChiki ? 22 : 20,
                    fontWeight: FontWeight.w500,
                    color: theme.onSurface,
                  ),
                ),
              ),
            ),
            
            // The popup preview bubble on key press
            if (_activePreviewChar == char && _activePreviewIndex == index)
              Positioned(
                top: -height * 1.3,
                child: KeyPreview(
                  character: char,
                  backgroundColor: theme.primary,
                  textColor: theme.onPrimary,
                  keyWidth: width,
                  keyHeight: height,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = KeyboardThemeData.getTheme(widget.settings);
    final rows = _getLayoutKeys();
    final double screenWidth = MediaQuery.of(context).size.width;
    
    // Spacing calculations based on DESIGN.md
    final double keyboardMargin = 8.0;
    final double keyGutter = 6.0;
    final int keysPerRow = 10;
    
    // Calculate key width fluidly
    final double keyWidth = (screenWidth - (keyboardMargin * 2) - (keyGutter * (keysPerRow - 1))) / keysPerRow;
    final double rowHeight = (widget.settings.keyboardHeight - 48 - 6 - 6 - 4) / 4; // Subtracting suggestion, divider, and spacing heights

    return Material(
      color: theme.background,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: double.infinity,
          height: widget.settings.keyboardHeight,
          child: Column(
            children: [
          // Suggestions Bar
          _buildSuggestionBar(theme),
          
          // Sohrai divider pattern
          SohraiDivider(color: theme.accentDivider),
          const SizedBox(height: 6),

          // Keyboard rows
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: keyboardMargin),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Row 1
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(rows[0].length, (index) {
                      final char = rows[0][index];
                      return _buildKey(
                        char: char,
                        width: keyWidth,
                        height: rowHeight,
                        theme: theme,
                        index: index,
                      );
                    }),
                  ),
                  
                  // Row 2
                  _layoutMode == KeyboardLayoutMode.english
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(rows[1].length, (index) {
                            final char = rows[1][index];
                            return Row(
                              children: [
                                _buildKey(
                                  char: char,
                                  width: keyWidth,
                                  height: rowHeight,
                                  theme: theme,
                                  index: 10 + index,
                                ),
                                if (index < rows[1].length - 1)
                                  SizedBox(width: keyGutter),
                              ],
                            );
                          }),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(rows[1].length, (index) {
                            final char = rows[1][index];
                            return _buildKey(
                              char: char,
                              width: keyWidth,
                              height: rowHeight,
                              theme: theme,
                              index: 10 + index,
                            );
                          }),
                        ),
                  
                  // Row 3
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Shift Key / Layout Mode Indicator
                      if (_layoutMode == KeyboardLayoutMode.english)
                        _buildKey(
                          char: 'Shift',
                          width: keyWidth * 1.3,
                          height: rowHeight,
                          theme: theme,
                          index: 99,
                          isFunctional: true,
                          customChild: Icon(
                            _isShiftActive ? Icons.keyboard_capslock : Icons.arrow_upward,
                            color: _isShiftActive ? theme.primary : theme.onSurface,
                          ),
                          onTap: () {
                            setState(() {
                              _isShiftActive = !_isShiftActive;
                            });
                          },
                        )
                      else
                        // Native tribal accent graphic or special mod character
                        _buildKey(
                          char: 'Mod',
                          width: keyWidth * 1.3,
                          height: rowHeight,
                          theme: theme,
                          index: 99,
                          isFunctional: true,
                          customChild: Text(
                            'ᱪᱤᱠᱤ',
                            style: GoogleFonts.notoSansOlChiki(
                              textStyle: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: theme.primary,
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _layoutMode = KeyboardLayoutMode.symbols;
                            });
                          },
                        ),

                      // Row 3 Character Keys
                      ...List.generate(rows[2].length, (index) {
                        final char = rows[2][index];
                        final double remainingWidth = screenWidth - (keyboardMargin * 2) - (keyWidth * 2.6) - (keyGutter * (rows[2].length + 1));
                        final double currentKeyWidth = remainingWidth / rows[2].length;
                        return _buildKey(
                          char: char,
                          width: currentKeyWidth,
                          height: rowHeight,
                          theme: theme,
                          index: 20 + index,
                        );
                      }),

                      // Backspace Key
                      _buildKey(
                        char: 'Del',
                        width: keyWidth * 1.3,
                        height: rowHeight,
                        theme: theme,
                        index: 100,
                        isFunctional: true,
                        customChild: Icon(Icons.backspace_outlined, color: theme.onSurface),
                        onTap: _deleteText,
                      ),
                    ],
                  ),
                  
                  // Row 4 (Functional Row)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Layout Switcher Toggle (?123 / Abc)
                      _buildKey(
                        char: 'Toggle',
                        width: keyWidth * 1.5,
                        height: rowHeight,
                        theme: theme,
                        index: 101,
                        isFunctional: true,
                        customChild: Text(
                          _layoutMode == KeyboardLayoutMode.symbols ? 'ᱚᱞ' : '?123',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        onTap: () {
                          setState(() {
                            if (_layoutMode == KeyboardLayoutMode.symbols) {
                              _layoutMode = KeyboardLayoutMode.olChiki;
                            } else {
                              _layoutMode = KeyboardLayoutMode.symbols;
                            }
                          });
                        },
                      ),

                      // Language Switcher (Ol Chiki <-> English)
                      _buildKey(
                        char: 'Lang',
                        width: keyWidth * 1.5,
                        height: rowHeight,
                        theme: theme,
                        index: 102,
                        isFunctional: true,
                        customChild: Icon(Icons.language, color: theme.secondary),
                        onTap: () {
                          setState(() {
                            if (_layoutMode == KeyboardLayoutMode.olChiki) {
                              _layoutMode = KeyboardLayoutMode.english;
                            } else {
                              _layoutMode = KeyboardLayoutMode.olChiki;
                            }
                          });
                        },
                      ),

                      // Spacebar Key
                      _buildKey(
                        char: ' ',
                        width: keyWidth * 4.2,
                        height: rowHeight,
                        theme: theme,
                        index: 103,
                        customChild: Text(
                          _layoutMode == KeyboardLayoutMode.olChiki ? 'ᱥᱟᱱᱛᱟᱲᱤ' : 'English',
                          style: GoogleFonts.notoSansOlChiki(
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: theme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ),
                        onTap: () => _insertText(' '),
                      ),

                      // Custom Period / Comma / Quick punctuation
                      _buildKey(
                        char: '᱾',
                        width: keyWidth * 1.1,
                        height: rowHeight,
                        theme: theme,
                        index: 104,
                        onTap: () => _insertText(_layoutMode == KeyboardLayoutMode.olChiki ? '᱾' : '.'),
                      ),

                      // Action Enter Key (Solid Terracotta/Primary color)
                      GestureDetector(
                        onTapDown: (_) => _triggerFeedback(),
                        onTapUp: (_) {
                          if (widget.onEnterPressed != null) {
                            widget.onEnterPressed!();
                          } else {
                            _insertText('\n');
                          }
                        },
                        child: Container(
                          width: keyWidth * 1.6,
                          height: rowHeight,
                          decoration: BoxDecoration(
                            gradient: theme.primaryGradient,
                            borderRadius: BorderRadius.circular(100.0), // full pill shape per DESIGN.md
                            boxShadow: [
                              BoxShadow(
                                color: theme.primary.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Icon(Icons.subdirectory_arrow_left, color: theme.onPrimary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    ),
    ),
  );
}
}
