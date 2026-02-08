import 'package:flutter/material.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/constants/app_assets.dart';

class EmptyStateWidget extends StatelessWidget {
  final String imagePath;
  final String? title;
  final String? description;
  final double? imageHeight;

  const EmptyStateWidget({
    super.key,
    this.imagePath = AppAssets.emptyStateImage,
    this.title,
    this.description,
    this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: tok.gap.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: imageHeight ?? 200,
              fit: BoxFit.contain,
            ),
            if (title != null) ...[
              SizedBox(height: tok.gap.lg),
              AppText(
                title!,
                size: AppTextSize.s18,
                weight: AppTextWeight.semibold,
                color: tx.neutral,
                textAlign: TextAlign.center,
              ),
            ],
            if (description != null) ...[
              SizedBox(height: tok.gap.sm),
              AppText(
                description!,
                size: AppTextSize.s14,
                color: tx.subtle,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
