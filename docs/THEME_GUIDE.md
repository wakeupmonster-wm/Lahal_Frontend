# Project Theme Usage Guide

This guide explains how to use the custom theme system in `lahal_application`. The theme is built on top of Flutter's Material 3 `ThemeData` and uses `ThemeExtension` for custom tokens (typography, spacing, specific colors).

## 1. Colors

Avoid hardcoding hex values. Use semantic roles defined in `ColorScheme` and `AppTextColors`.

### Accessing Colors
```dart
final cs = Theme.of(context).colorScheme;
final tx = Theme.of(context).extension<AppTextColors>()!;
final status = Theme.of(context).extension<AppColors>()!;
```

### Common Mappings
| UI Element | Color Role | Example Code |
| :--- | :--- | :--- |
| **Primary Background** | `colorScheme.surface` | `scaffoldBackgroundColor: cs.surface` |
| **Card Background** | `colorScheme.surfaceContainerHighest` | `color: cs.surfaceContainerHighest` |
| **Main Text** | `colorScheme.onSurface` | `color: cs.onSurface` |
| **Subtle/Hint Text** | `AppTextColors.subtle` | `color: tx.subtle` |
| **Primary Button** | `colorScheme.primary` | `backgroundColor: cs.primary` |
| **Borders** | `colorScheme.outline` | `borderColor: cs.outline` |
| **Success/Error** | `AppColors.success` / `error` | `color: status.success` |

> 💡 **Tip**: See `lib/utils/theme/color_guide.md` for a detailed mapping table.

## 2. Typography

Use `AppTypography` for consistent font sizes and weights. The app uses **Plus Jakarta Sans**.

### Usage
```dart
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';

// ...

Text(
  'Hello World',
  style: Theme.of(context).extension<AppTypography>()!.style(
    context,
    size: AppTextSize.s18, // s24, s18, s16, s14, s12, s10
    weight: AppTextWeight.semibold, // regular, medium, semibold, bold
    color: Theme.of(context).extension<AppTextColors>()!.primary,
  ),
)
```

## 3. Spacing & Layout (Responsive Tokens)

The app uses `AppTokens` for responsive metrics (gaps, insets, radius). These scale automatically based on screen width.

### Accessing Tokens
Use the `context` extension for easy access:
```dart
import 'package:lahal_application/utils/theme/app_tokens.dart';

// ...
final gap = context.gap;   // Spacing between elements
final inset = context.inset; // Padding inside containers
final tok = context.tok;   // Other tokens (radius, icon size)
```

### Examples
**Margins & Padding:**
```dart
Padding(
  padding: EdgeInsets.symmetric(
    horizontal: context.inset.screenH, // Standard screen horizontal padding
    vertical: context.inset.screenV,   // Standard screen vertical padding
  ),
  child: ...
)
```

**Spacing between widgets:**
```dart
Column(
  children: [
    Text('Title'),
    SizedBox(height: context.gap.md), // 20-24px gap
    Text('Subtitle'),
  ],
)
```

**Border Radius:**
```dart
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(context.tok.radiusMd), // 12-14px
  ),
)
```

## 4. Main Setup (`main.dart`)

The `main.dart` file handles the initialization of the responsive theme.
- **DevicePreview**: Wraps the app for testing different layouts.
- **Dynamic Scaling**: In the `builder` method, it calculates a `widthScale` based on the design width (430px) and injects the corresponding `AppTokens` into the theme.
- **System UI**: Sets the system overlay style (status bar transparency, etc.).

You generally don't need to touch this unless changing global configuration.

---
**Quick Checklist for New UI:**
1. Use `context.gap` and `context.inset` for all spacing.
2. Use `AppTypography` for all text.
3. Use `ColorScheme` and `AppTextColors` for all colors.
