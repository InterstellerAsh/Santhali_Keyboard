import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:santhali_keyboard/models/keyboard_settings.dart';
import 'package:santhali_keyboard/theme/keyboard_theme.dart';
import 'package:santhali_keyboard/widgets/sohrai_divider.dart';

class ThemesTab extends StatefulWidget {
  final KeyboardSettings settings;

  const ThemesTab({super.key, required this.settings});

  @override
  State<ThemesTab> createState() => _ThemesTabState();
}

class _ThemesTabState extends State<ThemesTab> {
  void _openColorPicker(String type, Color currentColor, Function(Color) onColorSelected) {
    Color selectedColor = currentColor;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select $type Color', style: GoogleFonts.beVietnamPro()),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (color) {
                selectedColor = color;
              },
              pickerAreaHeightPercent: 0.7,
              enableAlpha: false,
              displayThumbColor: true,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: KeyboardThemeData.getTheme(widget.settings).primary,
              ),
              child: const Text('Select', style: TextStyle(color: Colors.white)),
              onPressed: () {
                onColorSelected(selectedColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCustomThemeDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final theme = KeyboardThemeData.getTheme(widget.settings);
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: theme.background,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border.all(color: theme.primary.withOpacity(0.2), width: 2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: theme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Custom Theme Creator',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Define your custom earth-inspired palette.',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      color: theme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Primary Color Row
                  _buildColorSelectorRow(
                    label: 'Primary Accent (Terracotta/Action)',
                    color: widget.settings.customPrimaryColor,
                    onTap: () {
                      _openColorPicker('Primary Accent', widget.settings.customPrimaryColor, (color) {
                        widget.settings.setCustomColors(primary: color);
                        widget.settings.setThemeMode('custom');
                        setModalState(() {});
                      });
                    },
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  
                  // Secondary Color Row
                  _buildColorSelectorRow(
                    label: 'Secondary (Pills/Switches)',
                    color: widget.settings.customSecondaryColor,
                    onTap: () {
                      _openColorPicker('Secondary Accent', widget.settings.customSecondaryColor, (color) {
                        widget.settings.setCustomColors(secondary: color);
                        widget.settings.setThemeMode('custom');
                        setModalState(() {});
                      });
                    },
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  
                  // Background Color Row
                  _buildColorSelectorRow(
                    label: 'Keyboard Base (Background/Plate)',
                    color: widget.settings.customBackgroundColor,
                    onTap: () {
                      _openColorPicker('Base Background', widget.settings.customBackgroundColor, (color) {
                        widget.settings.setCustomColors(bg: color);
                        widget.settings.setThemeMode('custom');
                        setModalState(() {});
                      });
                    },
                    theme: theme,
                  ),
                  const SizedBox(height: 32),
                  
                  // Done Button
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                        ),
                        child: Text(
                          'Save & Apply Theme',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.onPrimary,
                          ),
                        ),
                        onPressed: () {
                          widget.settings.setThemeMode('custom');
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildColorSelectorRow({
    required String label,
    required Color color,
    required VoidCallback onTap,
    required KeyboardThemeData theme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.primary.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.beVietnamPro(
                  fontWeight: FontWeight.w500,
                  color: theme.onSurface,
                ),
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniKeyboardPreview(KeyboardThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.primary.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Suggestion chips row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('ᱡᱚᱦᱟᱨ', style: GoogleFonts.notoSansOlChiki(fontSize: 10, color: theme.primary)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('ᱚᱞ ᱪᱤᱠᱤ', style: GoogleFonts.notoSansOlChiki(fontSize: 10, color: theme.primary)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SohraiDivider(color: theme.accentDivider, height: 4),
          const SizedBox(height: 6),
          // Row 1 keys
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (i) {
              final chars = ['ᱚ', 'ᱛ', 'ᱜ', 'ᱝ', 'ᱞ'];
              return Container(
                width: 32,
                height: 28,
                decoration: BoxDecoration(
                  color: theme.surface,
                  borderRadius: BorderRadius.circular(4),
                  border: Border(bottom: BorderSide(color: theme.primary.withOpacity(0.2), width: 1.5)),
                ),
                alignment: Alignment.center,
                child: Text(chars[i], style: GoogleFonts.notoSansOlChiki(fontSize: 12, color: theme.onSurface)),
              );
            }),
          ),
          const SizedBox(height: 4),
          // Row 2 keys
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 44,
                height: 28,
                decoration: BoxDecoration(
                  color: theme.actionKeySurface,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: Text('ᱪᱤᱠᱤ', style: GoogleFonts.notoSansOlChiki(fontSize: 8, color: theme.primary, fontWeight: FontWeight.bold)),
              ),
              Container(
                width: 90,
                height: 28,
                decoration: BoxDecoration(
                  color: theme.surface,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: Text('ᱥᱟᱱᱛᱟᱲᱤ', style: GoogleFonts.notoSansOlChiki(fontSize: 10, color: theme.onSurface.withOpacity(0.6))),
              ),
              Container(
                width: 44,
                height: 28,
                decoration: BoxDecoration(
                  color: theme.primary,
                  borderRadius: BorderRadius.circular(100),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.subdirectory_arrow_left, size: 12, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard({
    required String id,
    required String name,
    required String colorsDesc,
    required List<Color> colorsPreview,
    required KeyboardThemeData theme,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () {
        widget.settings.setThemeMode(id);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? theme.primary : theme.onSurface.withOpacity(0.1),
            width: isActive ? 2.5 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: theme.primary.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  isActive ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isActive ? theme.primary : theme.onSurface.withOpacity(0.4),
                  size: 22,
                ),
                Row(
                  children: List.generate(colorsPreview.length, (index) {
                    return Container(
                      margin: const EdgeInsets.only(left: 4),
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: colorsPreview[index],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isActive ? theme.primary : theme.onSurface,
              ),
            ),
            Text(
              colorsDesc.toUpperCase(),
              style: GoogleFonts.beVietnamPro(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: theme.onSurface.withOpacity(0.5),
                letterSpacing: 0.5,
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
    
    return Scaffold(
      backgroundColor: theme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Hero
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primary.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appearance',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: theme.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Live Preview of current style:',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        color: theme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMiniKeyboardPreview(theme),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Theme Grid Header
              Text(
                'SELECT KEYBOARD THEME',
                style: GoogleFonts.beVietnamPro(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: theme.onSurface.withOpacity(0.5),
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 12),
              
              // Bento Grid of Themes
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.2,
                children: [
                  // Preset 1
                  _buildThemeCard(
                    id: 'kherwal',
                    name: 'Kherwal Heritage',
                    colorsDesc: 'Terracotta / Forest',
                    colorsPreview: [const Color(0xFF994126), const Color(0xFF376757), const Color(0xFFFCF9F8)],
                    theme: theme,
                    isActive: widget.settings.themeMode == 'kherwal',
                  ),
                  // Preset 2
                  _buildThemeCard(
                    id: 'slate',
                    name: 'Modern Slate',
                    colorsDesc: 'Charcoal / Silver',
                    colorsPreview: [const Color(0xFF303030), const Color(0xFF89726c), const Color(0xFFF3F0F0)],
                    theme: theme,
                    isActive: widget.settings.themeMode == 'slate',
                  ),
                  // Preset 3
                  _buildThemeCard(
                    id: 'gold',
                    name: 'Harvest Gold',
                    colorsDesc: 'Ochre / Gold / Dusk',
                    colorsPreview: [const Color(0xFF7F735F), const Color(0xFF221B0C), const Color(0xFFF0E1C8)],
                    theme: theme,
                    isActive: widget.settings.themeMode == 'gold',
                  ),
                  // Custom Theme Creator card
                  GestureDetector(
                    onTap: _showCustomThemeDialog,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: widget.settings.themeMode == 'custom' ? theme.surface : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: widget.settings.themeMode == 'custom' 
                              ? theme.primary 
                              : theme.primary.withOpacity(0.3),
                          width: widget.settings.themeMode == 'custom' ? 2.5 : 1.5,
                          style: widget.settings.themeMode == 'custom' ? BorderStyle.solid : BorderStyle.none, // wait, border dash can't be easily styled without custom painter, let's use outline with opacity
                        ),
                        gradient: widget.settings.themeMode != 'custom' 
                            ? SweepGradient(
                                colors: [
                                  theme.primary.withOpacity(0.1),
                                  theme.secondary.withOpacity(0.1),
                                  theme.primary.withOpacity(0.1),
                                ],
                              )
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: theme.primary,
                            size: 30,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Custom Theme',
                            style: GoogleFonts.beVietnamPro(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: theme.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
