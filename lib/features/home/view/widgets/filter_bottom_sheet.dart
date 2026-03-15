import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/features/home/controller/home_controller.dart';
import 'package:lahal_application/utils/components/bottom_sheets/animated_bottom_sheet.dart';
import 'package:lahal_application/utils/theme/app_button.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return AppAnimatedBottomSheet(
      children: [
        _buildHeader(tx),
        SizedBox(height: tok.gap.xl),
        _DistanceSection(controller: controller, tok: tok, tx: tx, cs: cs),
        SizedBox(height: tok.gap.lg),
        _RatingsSection(controller: controller, tok: tok, tx: tx),
        SizedBox(height: tok.gap.xl),
        _CuisineSection(controller: controller, tok: tok, tx: tx, cs: cs),
        SizedBox(height: tok.gap.xxl),
        _ActionButtons(controller: controller, tok: tok, cs: cs),
        SizedBox(height: tok.gap.lg),
      ],
    );
  }

  Widget _buildHeader(AppTextColors tx) {
    return AppText(
      AppStrings.filterResults,
      size: AppTextSize.s18,
      weight: AppTextWeight.bold,
      color: tx.neutral,
    );
  }
}

class _DistanceSection extends StatelessWidget {
  final HomeController controller;
  final AppTokens tok;
  final AppTextColors tx;
  final ColorScheme cs;

  const _DistanceSection({
    required this.controller,
    required this.tok,
    required this.tx,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 8),
              activeTrackColor: cs.primary,
              inactiveTrackColor: cs.surfaceContainerHighest,
              thumbColor: Colors.white,
              trackHeight: 4,
            ),
            child: Slider(
              value: controller.distanceRange.value,
              min: 0,
              max: 1000,
              onChanged: (value) => controller.updateDistanceRange(value),
            ),
          ),
        ),
      ],
    );
  }
}

class _RatingsSection extends StatelessWidget {
  final HomeController controller;
  final AppTokens tok;
  final AppTextColors tx;

  const _RatingsSection({
    required this.controller,
    required this.tok,
    required this.tx,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

class _CuisineSection extends StatelessWidget {
  final HomeController controller;
  final AppTokens tok;
  final AppTextColors tx;
  final ColorScheme cs;

  const _CuisineSection({
    required this.controller,
    required this.tok,
    required this.tx,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          "Cuisine",
          size: AppTextSize.s16,
          weight: AppTextWeight.bold,
          color: tx.neutral,
        ),
        SizedBox(height: tok.gap.md),
        Obx(
          () => Wrap(
            spacing: tok.gap.sm,
            runSpacing: tok.gap.sm,
            children: controller.allCuisines.map((cuisine) {
              final isSelected = controller.selectedCuisines.contains(cuisine);
              return GestureDetector(
                onTap: () => controller.toggleCuisine(cuisine),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: tok.gap.md,
                    vertical: tok.gap.xs,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? cs.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(tok.radiusLg),
                    border: Border.all(
                      color: isSelected ? cs.primary : cs.outlineVariant,
                    ),
                  ),
                  child: AppText(
                    cuisine,
                    size: AppTextSize.s14,
                    color: isSelected ? cs.onPrimary : tx.subtle,
                    weight: isSelected
                        ? AppTextWeight.bold
                        : AppTextWeight.medium,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final HomeController controller;
  final AppTokens tok;
  final ColorScheme cs;

  const _ActionButtons({
    required this.controller,
    required this.tok,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
          child: Obx(() {
            final hasFiltersChanged =
                controller.distanceRange.value != 200.0 ||
                controller.rating.value != 0 ||
                controller.selectedCuisines.isNotEmpty;

            return AppButton(
              radiusOverride: tok.radiusMd,
              label: "Show results",
              bgColorOverride: hasFiltersChanged
                  ? null
                  : cs.surfaceContainerHighest,
              fgColorOverride: hasFiltersChanged
                  ? null
                  : cs.onSurface.withOpacity(0.5),
              onPressed: hasFiltersChanged
                  ? () {
                      controller.applyFilters();
                      context.pop();
                    }
                  : null, // Disables button when false
            );
          }),
        ),
      ],
    );
  }
}
