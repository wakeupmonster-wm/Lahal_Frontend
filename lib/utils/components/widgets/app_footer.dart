import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lahal_application/utils/constants/app_svg.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: tok.gap.xl * 1.5,
        bottom: tok.gap.xxl * 4,
        left: tok.gap.lg,
        right: tok.gap.lg,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                AppSvg.logoIcon,
                width: tok.gap.xl,
                height: tok.gap.xl,
                colorFilter: ColorFilter.mode(
                  tx.subtle.withOpacity(0.5),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: tok.gap.xs),
              AppText(
                'Lahal',
                size: AppTextSize.s24,
                weight: AppTextWeight.bold,
                color: tx.subtle.withOpacity(0.5),
              ),
            ],
          ),
          SizedBox(height: tok.gap.xs),
          Row(
            children: [
              AppText(
                'Crafted with ',
                size: AppTextSize.s14,
                weight: AppTextWeight.medium,
                color: tx.subtle,
              ),
              const Icon(Icons.favorite, color: Colors.red, size: 16),
              AppText(
                ' in Indore, India',
                size: AppTextSize.s14,
                weight: AppTextWeight.medium,
                color: tx.subtle,
              ),
            ],
          ),
          SizedBox(height: tok.gap.md),
        ],
      ),
    );
  }
}
