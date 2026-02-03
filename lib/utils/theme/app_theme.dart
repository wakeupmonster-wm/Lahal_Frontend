import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lahal_application/utils/theme/app_palette.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/theme/color_theme_extension.dart';

// =============================
// Theme factory: light + dark using ColorScheme.fromSeed
// + Plus Jakarta Sans + specific font sizes
// =============================

class AppTheme {
  static final TextTheme _baseJakarta = GoogleFonts.plusJakartaSansTextTheme()
      .copyWith(
        // Map sizes to Material text slots you actually use
        headlineSmall: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ), // big titles
        titleMedium: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ), //Title Medium
        bodyLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ), //Body Medium
        labelMedium: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ), // small labels
        labelSmall: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ), // captions/tags
      );

  static ThemeData light() {
    // Map semantic roles to palette shades (Light theme)
    const scheme = ColorScheme(
      brightness: Brightness.light,

      // Brand
      primary: AppPalette.brand500,
      onPrimary: Colors.white,
      primaryContainer: AppPalette.brand100,
      onPrimaryContainer: AppPalette.brand900,

      // Secondary (we map to subtle brand/neutral accent)
      secondary: AppPalette.brand600,
      onSecondary: Colors.white,
      secondaryContainer: AppPalette.brand50,
      onSecondaryContainer: AppPalette.brand700,

      // Tertiary (optional accent)
      tertiary: AppPalette.brand700,
      onTertiary: Colors.white,
      tertiaryContainer: AppPalette.brand100,
      onTertiaryContainer: AppPalette.brand900,

      // Status
      error: AppPalette.error,
      onError: Colors.white,
      errorContainer: Color(0xFFFFEDEB),
      onErrorContainer: AppPalette.error,

      // Surfaces & text
      surface: AppPalette.lightBg, // scaffold background (white)
      onSurface: AppPalette.textPrimary, // main readable text (#212121)
      surfaceContainerHighest: AppPalette.grey50, // cards / elevated surfaces
      surfaceContainerLow:
          AppPalette.msgSentBg, // nested/light surface (msg sent bg)
      // Borders / outlines / dividers
      outline: AppPalette.strokeLight, // main border (E0..)
      outlineVariant: AppPalette.strokeVariant, // subtle border
      // Other
      shadow: Colors.black12,
      scrim: Colors.black54,
      inverseSurface: AppPalette.grey900,
      onInverseSurface: Colors.white,
      surfaceTint: AppPalette.brand500,
    );

    // Typography & text color tokens
    final appTypography = AppTypography.fromTextTheme(_baseJakarta);
    final appTextColors = AppTextColors(
      link: scheme.primary, // tappable links / CTAs
      primary: scheme.onSurface, // main readable text (body & headings)
      secondary: scheme.tertiary, // small accent text if needed
      tertiary: scheme.secondary, // alternative accent
      neutral: scheme.onSurface, // primary body text
      inverse: scheme.onPrimary, // text on primary background
      subtle: AppPalette.textSubtle, // placeholders / captions (#616161)
      muted: AppPalette.textMuted, // timestamps / disabled states (#9E9E9E)
      info: AppPalette.info, // semantic info for inline text
      warning: AppPalette.warning,
      error: scheme.error,
    );

    const appColor = AppColors(
      success: AppPalette.success,
      warning: AppPalette.warning,
      info: AppPalette.info,
      error: AppPalette.error,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: _baseJakarta,
      iconTheme: const IconThemeData(size: 24), // default icon size = 24
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        titleTextStyle: _baseJakarta.titleMedium?.copyWith(
          color: scheme.onSurface,
        ),
      ),

      // Inputs: use surfaceContainerLow as fill so fields sit subtly on page
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        hintStyle: _baseJakarta.labelMedium?.copyWith(
          color: AppPalette.textMuted,
        ),
      ),

      // Cards should use slightly different surface than scaffold
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Buttons
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: _baseJakarta.labelMedium,
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: scheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: _baseJakarta.labelMedium,
          foregroundColor: scheme.primary,
        ),
      ),

      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: scheme.outlineVariant),
        labelStyle: _baseJakarta.labelMedium,
      ),

      // Register extensions (tokens + colors + typography)
      extensions: [
        AppTokens.fromWidth(width: 430),
        appColor,
        appTypography,
        appTextColors,
      ],
    );
  }

  static ThemeData dark() {
    // Map semantic roles to palette shades (Dark theme)
    const scheme = ColorScheme(
      brightness: Brightness.dark,

      // Brand (choose a lighter brand shade so it stands out on dark bg)
      primary: AppPalette.brand300,
      onPrimary: Colors.black, // text/icons on primary (brand300 is light)
      primaryContainer: AppPalette.brand700,
      onPrimaryContainer: Colors.white,

      // Secondary / tertiary accents
      secondary: AppPalette.brand400,
      onSecondary: Colors.black,
      secondaryContainer: AppPalette.brand800,
      onSecondaryContainer: Colors.white,

      tertiary: AppPalette.brand200,
      onTertiary: Colors.black,
      tertiaryContainer: AppPalette.brand800,
      onTertiaryContainer: Colors.white,

      // Status
      error: AppPalette.error,
      onError: Colors.white,
      errorContainer: Color(0xFF4A1D1D),
      onErrorContainer: Colors.white,

      // Surfaces & text
      surface: AppPalette.dark1, // app background (dark)
      onSurface: Colors.white, // primary readable text on dark
      surfaceContainerHighest: AppPalette.dark3, // cards / elevated surfaces
      surfaceContainerLow: AppPalette.dark2, // nested sections
      // Borders / outlines / dividers
      outline: AppPalette.dark4, // borders on dark
      outlineVariant: AppPalette.dark3, // subtle variant
      // Other
      shadow: Colors.black,
      scrim: Colors.black54,
      inverseSurface: AppPalette.lightBg, // used for snackbars if needed
      onInverseSurface: AppPalette.textPrimary,
      surfaceTint: AppPalette.brand300,
    );

    // Typography & text color tokens adjusted for dark
    final appTypography = AppTypography.fromTextTheme(_baseJakarta);

    final appTextColors = AppTextColors(
      link: scheme.primary, // brand accent (brand300 on dark)
      primary: scheme.onSurface, // white-ish text on dark background
      secondary: scheme.tertiary,
      tertiary: scheme.secondary,
      neutral: scheme.onSurface,
      inverse: scheme
          .onPrimary, // text on primary (in dark we used black on light brand)
      subtle: scheme.onSurface.withOpacity(0.75), // dimmer white
      muted: AppPalette.grey400, // use slightly darker grey for muted info
      info: AppPalette.info,
      warning: AppPalette.warning,
      error: scheme.error,
    );

    const appColor = AppColors(
      success: AppPalette.success,
      warning: AppPalette.warning,
      info: AppPalette.info,
      error: AppPalette.error,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: _baseJakarta,
      iconTheme: const IconThemeData(size: 24),
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        titleTextStyle: _baseJakarta.titleMedium?.copyWith(
          color: scheme.onSurface,
        ),
      ),

      // Inputs: filled style for dark
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        hintStyle: _baseJakarta.labelMedium?.copyWith(
          color: AppPalette.grey400,
        ),
      ),

      // Cards should use a slightly different dark surface
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Buttons
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: _baseJakarta.labelMedium,
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: scheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: _baseJakarta.labelMedium,
          foregroundColor: scheme.primary,
        ),
      ),

      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: scheme.outlineVariant),
        labelStyle: _baseJakarta.labelMedium,
      ),

      // Register extensions (tokens + colors + typography)
      extensions: [
        AppTokens.fromWidth(width: 430),
        appColor,
        appTypography,
        appTextColors,
      ],
    );
  }
}

//
///| **ColorScheme Property**     | **Purpose (Use for)**                         | **Example in UI**                             | **Tips / Notes**                           |
// | ---------------------------- | --------------------------------------------- | --------------------------------------------- | ------------------------------------------ |
// | 🎨 `primary`                 | Main brand color (buttons, links, highlights) | Filled buttons, main CTA, progress indicator  | In dark mode use lighter shade of brand    |
// | ⚪ `onPrimary`                | Text or icon **on top of primary background** | Text inside primary button                    | Usually white in light mode, black in dark |
// | 💠 `primaryContainer`        | Soft background using brand tint              | Chips, tags, small accent cards               | Use for subtle brand highlight             |
// | 🖋 `onPrimaryContainer`      | Text/icon **on top of** primaryContainer      | Label inside chip or tag                      | Contrast color (often brand-900 or white)  |
// | 🟣 `secondary`               | Secondary brand or accent color               | Secondary buttons, toggle ON color, icons     | Optional if app uses dual-brand colors     |
// | ⚫ `onSecondary`              | Text/icon on secondary background             | Text in secondary button                      | Usually white or dark grey                 |
// | 💭 `secondaryContainer`      | Soft secondary background                     | Secondary chips or neutral badges             | Subtle tint of secondary color             |
// | ✍️ `onSecondaryContainer`    | Text/icon on top of that                      | Text inside secondary chip                    | High contrast color                        |
// | ⚪ `surface`                  | App background (whole screen)                 | Scaffold background, cards, dialogs           | White (light) / near black (dark)          |
// | 🖤 `onSurface`               | Text/icon **on surface**                      | All normal text, headings                     | Black-ish in light, white-ish in dark      |
// | 📦 `surfaceContainerHighest` | Elevated card / sheet bg                      | Elevated cards, modals, nav bars              | Slightly different from surface            |
// | ⚪ `surfaceContainerLow`      | Lower elevation bg                            | For nested sections                           | Useful for contrast layering               |
// | 🧱 `outline`                 | Border, divider color                         | Text field border, card border                | Grey tone, different for light/dark        |
// | ⚙️ `outlineVariant`          | Soft border color                             | Subtle separators                             | Even lighter than outline                  |
// | 🔴 `error`                   | Error background or icon                      | Error text, alert dialogs                     | Bright red-ish tone                        |
// | ⚪ `onError`                  | Text on error background                      | “Retry” text in red banner                    | Usually white                              |
// | 🔴 `errorContainer`          | Soft error background                         | Warning chip or alert card                    | Use lighter red                            |
// | ⚪ `onErrorContainer`         | Text on top of errorContainer                 | Error chip label                              | Contrast color                             |
// | 🧱 `inverseSurface`          | Inverse background                            | Snackbars, bottom bar (dark on light)         | Opposite of surface                        |
// | ⚪ `onInverseSurface`         | Text on inverseSurface                        | Text in snackbar                              | Contrast color (white/black)               |
// | 💧 `surfaceTint`             | Tint used for Material3 elevation             | Used internally by Flutter (no need manually) | Leave as is                                |

///
