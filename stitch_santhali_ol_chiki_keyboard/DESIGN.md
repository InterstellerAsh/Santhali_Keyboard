---
name: Kherwal Heritage
colors:
  surface: '#fcf9f8'
  surface-dim: '#dcd9d9'
  surface-bright: '#fcf9f8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f6f3f2'
  surface-container: '#f0eded'
  surface-container-high: '#eae7e7'
  surface-container-highest: '#e4e2e1'
  on-surface: '#1b1c1c'
  on-surface-variant: '#56423d'
  inverse-surface: '#303030'
  inverse-on-surface: '#f3f0f0'
  outline: '#89726c'
  outline-variant: '#dcc1b9'
  surface-tint: '#9c4328'
  primary: '#994126'
  on-primary: '#ffffff'
  primary-container: '#b9583b'
  on-primary-container: '#fffbff'
  inverse-primary: '#ffb59f'
  secondary: '#376757'
  on-secondary: '#ffffff'
  secondary-container: '#baeed9'
  on-secondary-container: '#3d6d5d'
  tertiary: '#655b48'
  on-tertiary: '#ffffff'
  tertiary-container: '#7f735f'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdbd1'
  primary-fixed-dim: '#ffb59f'
  on-primary-fixed: '#3a0a00'
  on-primary-fixed-variant: '#7d2c13'
  secondary-fixed: '#baeed9'
  secondary-fixed-dim: '#9ed1bd'
  on-secondary-fixed: '#002117'
  on-secondary-fixed-variant: '#1d4f40'
  tertiary-fixed: '#f0e1c8'
  tertiary-fixed-dim: '#d3c5ad'
  on-tertiary-fixed: '#221b0c'
  on-tertiary-fixed-variant: '#4f4634'
  background: '#fcf9f8'
  on-background: '#1b1c1c'
  surface-variant: '#e4e2e1'
typography:
  display-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Be Vietnam Pro
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  key-label-lg:
    fontFamily: Be Vietnam Pro
    fontSize: 22px
    fontWeight: '500'
    lineHeight: 28px
  key-label-sm:
    fontFamily: Be Vietnam Pro
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-md:
    fontFamily: Be Vietnam Pro
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-caps:
    fontFamily: Be Vietnam Pro
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  key-gutter: 6px
  key-padding-v: 12px
  key-padding-h: 8px
  keyboard-margin: 8px
  touch-target-min: 48px
---

## Brand & Style

The design system bridges ancient cultural identity with modern mobile utility. It is designed to feel grounded, tactile, and respectful of the Santhali heritage while maintaining the high-performance standards required for an input method editor (IME). 

The visual language follows a **Modern-Ethnic** approach—stripping away excessive ornamentation in favor of clean, Material-inspired architecture, accented by subtle geometric patterns inspired by Sohrai and Santhal wall art. The emotional response should be one of "Digital Belonging": a tool that feels like a natural extension of the user's cultural expression.

**Design Principles:**
- **Earth-Rooted:** Utilizing a palette derived from natural pigments (terracotta, forest, sand).
- **Radical Legibility:** Prioritizing the Ol Chiki script's unique geometry through high-contrast environments.
- **Tactile Comfort:** Large, soft-edged touch targets that reduce friction and fatigue during long typing sessions.

## Colors

This design system utilizes a high-contrast, earthy palette to ensure WCAG AAA compliance, which is critical for a keyboard app often used in varying lighting conditions.

- **Terracotta Earth (#C86446):** The primary action color, used for key highlights, active states, and primary buttons.
- **Deep Forest Green (#1B4D3E):** The secondary color, used for functional toggles, shift states, and secondary navigation.
- **Warm Cream (#FDFBF7):** The global background to minimize eye strain compared to pure white.
- **Light Sand (#F5F0E6):** The surface color for keyboard keys and container elements, providing a subtle lift from the background.
- **Charcoal (#2D2D2D):** The primary text and glyph color, ensuring maximum legibility for Ol Chiki and Latin characters.

## Typography

The typography system relies on **Be Vietnam Pro** for its clean, open counters and contemporary feel, which complements the structural nature of Ol Chiki Unicode characters. 

**Implementation Notes:**
- **Ol Chiki Rendering:** Ensure the system font stack prioritizes specialized Santhali fonts (like Noto Sans Ol Chiki) to maintain character integrity.
- **Key Labels:** The `key-label-lg` style is the default for alphabetic keys. For keys with secondary symbols (long-press), use `key-label-sm` in the top-right corner of the key.
- **Dynamic Type:** All labels must scale with system accessibility settings without breaking the keyboard grid.

## Layout & Spacing

The layout is built on an **8px base grid**, but optimized specifically for the constraints of a mobile keyboard. 

- **Keyboard Grid:** Uses a fluid width with fixed gutters (`key-gutter`). The vertical height of the keyboard should be adjustable by the user, but the default "Comfortable" setting uses a 56px row height.
- **Touch Targets:** No interactive element (key, toggle, or icon) should have a hit state smaller than 48px x 48px. 
- **Safe Areas:** Padding is increased at the bottom of the keyboard to account for gesture navigation bars on modern devices, ensuring the spacebar is never accidentally triggered.

## Elevation & Depth

In alignment with modern Material design, this system avoids heavy drop shadows in favor of **Tonal Layers**.

- **Level 0 (Background):** Warm Cream (#FDFBF7).
- **Level 1 (Keyboard Plate):** Light Sand (#F5F0E6) with a subtle inner stroke (1px, 5% opacity charcoal) to define the typing area.
- **Level 2 (Standard Keys):** Use a flat surface with a slightly darker bottom border (2px) to simulate a physical key press feel.
- **Level 3 (Pop-ups/Tooltips):** When a key is pressed, the character "preview" uses a soft ambient shadow (12% opacity primary color) to appear as if it is floating above the keyboard.
- **Active State:** When a key is held, it transitions to the Primary Terracotta color with an inset shadow to indicate a "pressed" state.

## Shapes

The shape language is defined by extreme roundedness to evoke a friendly, modern, and accessible feel.

- **Standard Keys:** Use a `rounded-lg` (16px) or `rounded-xl` (24px) radius depending on the key width.
- **Action Keys (Enter/Shift):** Use a full pill-shape (radius: 100px) to distinguish functional keys from character keys.
- **Container Elements:** Settings cards and modal sheets use a 32px top-corner radius, following the Material You aesthetic.
- **Geometric Accents:** Use 45-degree angled patterns in the background of the keyboard plate or top-bar to nod to traditional Santhal architecture.

## Components

### Keyboard Keys
- **Character Keys:** Light Sand surface, Charcoal text. 
- **Functional Keys (Shift, Backspace):** Subtle Tonal Gray or Secondary Green tint.
- **Primary Action (Enter/Done):** Solid Terracotta Earth with White text for maximum prominence.

### Tooltips & Previews
- When a user touches a key, a large preview bubble appears above the finger. This bubble should use the Primary color for the character to reinforce the "Active" state.

### Chips & Language Switchers
- Rounded pill shapes used in the "top bar" of the keyboard for word suggestions and language switching (e.g., Ol Chiki <-> English).

### Input Fields (Settings)
- Outlined fields with a 2px stroke in the Secondary Green color when focused. The label should float above the border.

### Tribal Accents (Dividers)
- Instead of simple lines, use a repeating geometric "Sohrai" pattern (small triangles or diamonds) as a 4px tall divider between the suggestion bar and the keyboard keys.