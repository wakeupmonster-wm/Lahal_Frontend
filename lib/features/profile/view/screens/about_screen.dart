import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/utils/components/appbar/internal_app_bar.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/constants/app_svg.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerHighest.withValues(alpha: 3),
      appBar: InternalAppBar(
        title: AppStrings.about,
        centerTitle: false,
        backgroundColor: cs.surface,
      ),
      body: Column(
        children: [
          // SizedBox(height: tok.gap.md),
          _buildItem(
            context,
            AppStrings.termsOfService,
            onTap: () => context.push(AppRoutes.termsScreen),
            showArrow: true,
          ),
          _buildDivider(cs),
          _buildItem(
            context,
            AppStrings.privacyPolicy,
            onTap: () => context.push(AppRoutes.privacyScreen),
            showArrow: true,
          ),
          _buildDivider(cs),
          _buildItem(
            context,
            AppStrings.appVersion,
            trailing: AppText(
              AppStrings.versionNumber,
              size: AppTextSize.s14,
              color: tx.subtle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ColorScheme cs) {
    return Container(
      color: cs.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Divider(
          color: cs.outlineVariant.withOpacity(0.5),
          thickness: 0.8,
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    String title, {
    VoidCallback? onTap,
    Widget? trailing,
    bool showArrow = false,
  }) {
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final tok = Theme.of(context).extension<AppTokens>()!;
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,

      child: Container(
        color: cs.surface,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: tok.gap.lg,
            vertical: tok.gap.md,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                title,
                size: AppTextSize.s16,
                color: tx.primary,
                weight: AppTextWeight.semibold,
              ),
              if (trailing != null) trailing,
              if (showArrow)
                SvgPicture.asset(AppSvg.rightArrowIcon, color: tx.primary),
            ],
          ),
        ),
      ),
    );
  }
}
