import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/features/home/controller/home_controller.dart';
import 'package:lahal_application/utils/theme/app_button.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';

/// A BottomSheet widget that displays filter options with staggered animations.
///
/// This widget uses a [StatefulWidget] to manage an [AnimationController].
/// It leverages separate [Animation]s for different child components to create
/// a "waterfall" or "staggered" entrance effect, similar to apps like Zomato.
class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  /// Static helper to show the bottom sheet.
  /// Uses [showModalBottomSheet] with transparent background to allow custom styling.
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet>
    with SingleTickerProviderStateMixin {
  // Access the HomeController to manage filter state via GetX
  final HomeController controller = Get.find<HomeController>();

  // --- Animation Controllers & Tweens ---
  late AnimationController _animController;

  // Individual animations for staggered effects
  late Animation<Offset> _pullBarSlide;
  late Animation<double> _pullBarFade;

  late Animation<Offset> _titleSlide;
  late Animation<double> _titleFade;

  late Animation<Offset> _distanceSlide;
  late Animation<double> _distanceFade;

  late Animation<Offset> _ratingSlide;
  late Animation<double> _ratingFade;

  late Animation<Offset> _buttonSlide;
  late Animation<double> _buttonFade;

  @override
  void initState() {
    super.initState();

    // Initialize the main animation controller
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600), // Total animation duration
    );

    // --- Define Staggered Intervals ---
    // The interval (0.0 to 1.0) dictates when each animation starts and ends
    // relative to the total duration.

    // 1. Pull Bar (0ms - 200ms approx)
    _pullBarSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.0, 0.3, curve: Curves.easeOutQuad),
          ),
        );
    _pullBarFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    // 2. Title "Filter results" (100ms - 300ms approx)
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.1, 0.4, curve: Curves.easeOutQuad),
          ),
        );
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.1, 0.4, curve: Curves.easeOut),
      ),
    );

    // 3. Distance Range Section (200ms - 400ms approx)
    _distanceSlide =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.2, 0.5, curve: Curves.easeOutQuad),
          ),
        );
    _distanceFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
      ),
    );

    // 4. Ratings Section (300ms - 500ms approx)
    _ratingSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.3, 0.6, curve: Curves.easeOutQuad),
          ),
        );
    _ratingFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
      ),
    );

    // 5. Buttons (400ms - 600ms approx)
    _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.4, 0.7, curve: Curves.easeOutQuad),
          ),
        );
    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );

    // Start the animation immediately when the widget is built
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>();
    final tx = Theme.of(context).extension<AppTextColors>();
    final cs = Theme.of(context).colorScheme;

    // Safety check for theme extensions
    if (tok == null || tx == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: const Text('Theme Error: Extensions not found'),
      );
    }

    // Main Container
    return Container(
      padding: EdgeInsets.all(tok.gap.lg),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(tok.radiusLg * 2),
          topRight: Radius.circular(tok.radiusLg * 2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------------------------------------------------
          // 1. Pull Bar Animation
          // ---------------------------------------------------------
          FadeTransition(
            opacity: _pullBarFade,
            child: SlideTransition(
              position: _pullBarSlide,
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: tok.gap.lg),

          // ---------------------------------------------------------
          // 2. Title Animation
          // ---------------------------------------------------------
          FadeTransition(
            opacity: _titleFade,
            child: SlideTransition(
              position: _titleSlide,
              child: AppText(
                AppStrings.filterResults,
                size: AppTextSize.s18,
                weight: AppTextWeight.bold,
                color: tx.neutral,
              ),
            ),
          ),
          SizedBox(height: tok.gap.xl),

          // ---------------------------------------------------------
          // 3. Distance Range Animation
          // ---------------------------------------------------------
          FadeTransition(
            opacity: _distanceFade,
            child: SlideTransition(
              position: _distanceSlide,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        AppStrings.distanceRangeLabel,
                        size: AppTextSize.s16,
                        weight: AppTextWeight.bold,
                        color: tx.neutral,
                      ),
                      Obx(
                        () => AppText(
                          '${controller.distanceRange.value.toInt()} km',
                          size: AppTextSize.s14,
                          weight: AppTextWeight.medium,
                          color: tx.subtle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: tok.gap.sm),
                  Obx(
                    () => SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: cs.primary,
                        inactiveTrackColor: cs.surfaceContainerHighest,
                        thumbColor: Colors.white,
                        activeTickMarkColor: Colors.transparent,
                        inactiveTickMarkColor: Colors.transparent,
                        overlayColor: cs.primary.withOpacity(0.12),
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 10,
                          elevation: 4,
                        ),
                      ),
                      child: Slider(
                        value: controller.distanceRange.value,
                        min: 0,
                        max: 1000,
                        onChanged: (value) =>
                            controller.updateDistanceRange(value),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: tok.gap.lg),

          // ---------------------------------------------------------
          // 4. Ratings Animation
          // ---------------------------------------------------------
          FadeTransition(
            opacity: _ratingFade,
            child: SlideTransition(
              position: _ratingSlide,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    AppStrings.ratingsLabel,
                    size: AppTextSize.s16,
                    weight: AppTextWeight.bold,
                    color: tx.neutral,
                  ),
                  SizedBox(height: tok.gap.md),
                  Obx(
                    () => Row(
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        final isSelected = controller.rating.value >= starIndex;
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => controller.updateRating(starIndex),
                          child: Padding(
                            padding: EdgeInsets.only(right: tok.gap.sm),
                            child: Icon(
                              isSelected ? Icons.star : Icons.star_border,
                              color: isSelected
                                  ? Colors.amber
                                  : tx.subtle.withOpacity(0.3),
                              size: 32,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: tok.gap.xxl),

          // ---------------------------------------------------------
          // 5. Buttons Animation
          // ---------------------------------------------------------
          FadeTransition(
            opacity: _buttonFade,
            child: SlideTransition(
              position: _buttonSlide,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      radiusOverride: tok.radiusMd,
                      label: AppStrings.clearFilter,
                      bgColorOverride: cs.surface,
                      fgColorOverride: cs.primary,
                      onPressed: () {
                        controller.clearFilters();
                        context.pop();
                      },
                    ),
                  ),
                  SizedBox(width: tok.gap.md),
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      radiusOverride: tok.radiusMd,
                      label: AppStrings.reset,
                      onPressed: () {
                        controller.applyFilters();
                        context.pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: tok.gap.lg),
        ],
      ),
    );
  }
}
