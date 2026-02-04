// main.dart
import 'package:flutter/material.dart';

///--------

class AppPalette {
  // Brand seed (base hue)
  static const seed = Color(0xFF46C7CD);

  static const brand50 = Color(0xFFEDF9FA); // Very light tint
  static const brand100 = Color(0xFFC6EEF0); // Secondary tint, chip bg
  static const brand200 = Color(0xFFAAE5E8);
  static const brand300 = Color(0xFF7BDBE0);
  static const brand400 = Color(0xFF6BD2D7);
  static const brand500 = Color(0xFF047861); // Primary green requested by user
  static const brand600 = Color(0xFF40B5BB);
  static const brand700 = Color(0xFF328D92); // Button Of match screen
  static const brand800 = Color(0xFF276D71);
  static const brand900 = Color(0xFF1D5456);

  // ------------------------
  // ✅ Semantic colors
  // ------------------------
  static const info = Color(0xFF46C7CD);
  static const success = Color(0xFF12D18E);
  static const warning = Color(0xFFFACC15);
  static const error = Color(0xFFF75555);
  static const Color golden = Color(0xF4FFCC00);

  // ------------------------
  // 🩶 Grey ramp (neutral surfaces & text)
  // ------------------------
  static const grey50 = Color(
    0xFFFAFAFA,
  ); // Background light surface / Message sent / Card background
  static const grey100 = Color(
    0xFFEEEEEE,
  ); // Borders, unselected elements, divider
  static const grey200 = Color(0xFFD1D1D7);
  static const grey300 = Color(0xFFBDBCC5);
  static const grey400 = Color(0xFFB0AFBA); // Muted text or icons
  static const grey500 = Color(0xFF9E9E9E); // Hint / placeholder / timestamp
  static const grey600 = Color(0xFF8E8D9A); // Secondary label or icons
  static const grey700 = Color(0xFF616161); // Subtitles, secondary text
  static const grey800 = Color(0xFF56555D); // Tertiary text
  static const grey900 = Color(
    0xFF212121,
  ); // ✅ Main readable text (Text/General/Text Light)

  // ------------------------
  // 🎨 Backgrounds & surfaces
  // ------------------------
  static const lightBg = Color(0xFFFFFFFF); // Default background (surface)
  static const msgSentBg = Color(0xFFF5F5F5); // Message sent Card Bg
  //static const lightCard = Color(0xFFFAFAFA); // Card background

  // -------------------------------------------------------
  // 📏 BORDER COLORS (for outline, dividers, selections)
  // -------------------------------------------------------
  static const strokeLight = Color(
    //  0xFFEEEEEE, -- grey 100
    0xFFE0E0E0,
  );
  // Outline variant (slightly darker)
  // Selection borders / tabs (E0E0E0–E0E0E4 equivalent),  button border, radio, tab border // button border, radio, tab border
  static const strokeVariant = Color(
    0xFFD1D1D7,
  ); // Disabled text or secondary outline

  // ------------------------
  // ✏️ Text colors (semantic)
  // ------------------------
  static const textPrimary = Color(
    0xFF000000,
  ); // Pure black requested for headings
  static const textSubtle = Color(0xFF6E6E6E); // Grey 1 requested
  static const textMuted = Color(0xFF8A8A8A); // Grey 2 requested
  static const textInverse = Color(0xFFFFFFFF); // text on dark/colored bg

  // ------------------------
  // 🌑 Dark surfaces (used in dark theme)
  // ------------------------
  static const dark1 = Color(0xFF181A20); // App bg
  static const dark2 = Color(0xFF1E2025); // Elevated surfaces
  static const dark3 = Color(0xFF1F222A); // Cards
  static const dark4 = Color(0xFF262A35); // Border contrast
  static const dark5 = Color(0xFF35383F); // Overlay
}

// Raw brand & neutral colors (not used directly in widgets)
// ! This is for reference only
class UnusedPalette {
  // Brand seed (from your palette)
  static const seed = Color(0xFF46C7CD);

  // Optional ramp (useful for charts or custom mapping)
  // We are using two button for cancle, reset, back we are using this Light Button Bg
  static const brand50 = Color(0xFFEDF9FA);
  // Light Button Border,In My Profile Screen we have Super Like Container in that container we are using this as bg color for that container
  static const brand100 = Color(0xFFC6EEF0);
  static const brand200 = Color(0xFFAAE5E8);
  static const brand300 = Color(0xFF7BDBE0);
  static const brand400 = Color(0xFF6BD2D7);
  // Primary Button Bg, Hint Text when Laoding state/ Active Tab bar bg
  static const brand500 = Color(0xFF46c7cd);
  // Button on match Screen
  static const brand600 = Color(0xFF40B5BB);
  static const brand700 = Color(0xFF328D92);
  static const brand800 = Color(0xFF276D71);
  static const brand900 = Color(0xFF1D5456);

  // Status
  static const info = Color(0xFF46C7CD);
  static const success = Color(0xFF12D18E);
  static const warning = Color(0xFFFACC15);
  static const error = Color(0xFFF75555);

  // Greys
  // Textfield bg // On Chat Screen when You Blocked this account Card Bg, FWB Redme your Code Container Bg
  static const grey50 = Color(0xFFFAFAFA);
  // Textfield Border, Progress bar unselected, Slider unselected, On Notification Screen Icon Border, divider, Card Border FWB, Faq Card Border
  static const grey100 = Color(0xFFEEEEEE);
  static const grey200 = Color(0xFFD1D1D7);
  static const grey300 = Color(0xFFBDBCC5);
  static const grey400 = Color(0xFFB0AFBA);
  static const grey500 = Color(0xFF9C9BA9); // Plus for photo upload
  static const grey600 = Color(
    0xFF8E8D9A,
  ); // Buttons Bar Icons, Subtitle - Search
  static const grey700 = Color(0xFF616161); // Subtitle - Mainly Used
  // Subtitle - Profile Preview Subtitle
  static const grey800 = Color(0xFF56555D);
  static const grey900 = Color(0xFF424147); // Subtitle

  // Dark neutrals for surfaces in dark theme
  static const dark1 = Color(0xFF181A20);
  static const dark2 = Color(0xFF1E2025);
  static const dark3 = Color(0xFF1F222A);
  static const dark4 = Color(0xFF262A35);
  static const dark5 = Color(0xFF35383F);

  // Background colors
  static const lightBg = Color(0xFFFFFFFF); // on Button , On Recived Messages,

  //-- Out of Material Colors please find matching color from above schema
  // Text/Components/Text Form Default 500 - #9E9E9E - Hint textfield/Textfield Placeholder/ Notification Time - muted
  // Surface/Light & Dark/Light 9 --  E0E0E0 -- Button Borders, Unselected Radio Button, Tab Boder IN Faq, Selection Border at Profile Setup
  // F5F5F5 -- Message Sent
}
