# Color Guide — MAFS (Developer + Designer Reference)

> Short: Designer provides palette; developers use *semantic roles*.  
> This document explains *which role to use where*, examples, and the canonical mapping file.

---

## 1) WHY semantic roles?
Designer has many raw colors (Aqua/600, Grey/100, etc.).  
Developers should **never** hardcode hexs in UI. Instead use:
- `ColorScheme` (Material roles: primary, onPrimary, surface, onSurface, outline, ...)
- ThemeExtensions for app-specific tokens: `AppTextColors`, `AppColors`, `AppTokens`, `AppTypography`.

Benefits:
- Light/Dark friendly (change mapping once, UI auto-updates)
- Human-readable: `text.neutral` is clearer than `#212121`
- Easier to onboard devs

---

## 2) Files / places to look
- `lib/theme/app_palette.dart` — raw color ramp (MAFS/Aqua/..). **Do not use directly** in app widgets (except for custom charts).
- `lib/theme/app_theme.dart` — builds `ThemeData` for light/dark and maps roles.
- `lib/theme/app_text_colors.dart` — ThemeExtension for text color tokens (text.neutral, text.subtle, etc.)
- `lib/theme/app_colors.dart` — ThemeExtension for status colors (success, warning, info, error)
- `design/figma_to_role.json` — canonical mapping from Figma token name → semantic role
- `lib/screens/color_reference.dart` — (dev) shows Figma token ↔ role ↔ hex at runtime (useful for QA)

---

## 3) Core semantic roles (use these)
Use these roles everywhere in UI code.

### ColorScheme (Material)
- `colorScheme.primary` — main brand color (CTA, filled button bg, link)
- `colorScheme.onPrimary` — text/icons on primary bg
- `colorScheme.primaryContainer` — subtle brand container (chips, tag bg)
- `colorScheme.secondary` — secondary accent
- `colorScheme.surface` — scaffold/page background
- `colorScheme.onSurface` — body text color
- `colorScheme.surfaceContainerHighest` — card bg / elevated surfaces
- `colorScheme.surfaceContainerLow` — nested surfaces (inputs, message sent bg)
- `colorScheme.outline` — borders & dividers
- `colorScheme.outlineVariant` — subtle border variant
- `colorScheme.error` / `colorScheme.onError` — error colors

### AppTextColors (text-specific)
- `tx.primary` / `text.primary` — heading / body
- `tx.subtle` — caption/hint/placeholder
- `tx.inverse` — text on colored surfaces (e.g., on brand)
- `tx.link` — clickable text (maps to brand)

### AppColors (status/semantic)
- `appColor.success`, `appColor.warning`, `appColor.info`, `appColor.error`

### Tokens & typography (spacing/fonts)
- `AppTokens` for paddings/gaps/icon sizes
- `AppTypography` for sizes (s24,s18,s16,s14,s12,s10) and weights

---

## 4) Quick mapping cheat-sheet (where to use what)

- **Scaffold / Screen background** → `colorScheme.surface`
- **Card background** → `colorScheme.surfaceContainerHighest`
- **Normal text / heading** → `colorScheme.onSurface` (or `AppTextColors.neutral`)
- **Caption / placeholder** → `AppTextColors.subtle`
- **Primary filled button** → `colorScheme.primary` (bg) + `colorScheme.onPrimary` (text)
- **Outlined button** → border = `colorScheme.outline`, text = `colorScheme.primary`
- **TextFields** → fill = `colorScheme.surfaceContainerLow`, border = `colorScheme.outline`, focused border = `colorScheme.primary`
- **Dividers / borders** → `colorScheme.outline` or `outlineVariant`
- **Error UI** → `colorScheme.error`, `colorScheme.onError`
- **Success / Info badges** → `AppColors.success/info`

---

## 5) Example Flutter usage (copy-paste)

```dart
final cs = Theme.of(context).colorScheme;
final tx = Theme.of(context).extension<AppTextColors>()!;
final app = Theme.of(context).extension<AppColors>()!;

// Heading
Text('Title',
  style: Theme.of(context).extension<AppTypography>()!
    .style(context, size: AppTextSize.s24, weight: AppTextWeight.semibold, color: tx.primary)
);

// Primary Filled button
FilledButton(
  onPressed: (){},
  style: FilledButton.styleFrom(
    backgroundColor: cs.primary,
    foregroundColor: cs.onPrimary,
  ),
  child: Text('Continue'),
);

// TextField
TextField(
  style: TextStyle(color: cs.onSurface),
  decoration: InputDecoration(
    filled: true,
    fillColor: cs.surfaceContainerLow,
    border: OutlineInputBorder(borderSide: BorderSide(color: cs.outline)),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: cs.primary, width:1.5)),
    hintStyle: TextStyle(color: tx.subtle),
  ),
);

// Card
Card(
  color: cs.surfaceContainerHighest,
  child: Padding(padding: EdgeInsets.all(context.tok.inset.card), child: Text('Card', style: TextStyle(color: cs.onSurface))),
);