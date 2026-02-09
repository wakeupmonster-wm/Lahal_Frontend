import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/utils/components/appbar/internal_app_bar.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/constants/app_svg.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';

class AccountManagementScreen extends StatelessWidget {
  const AccountManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: InternalAppBar(
        title: AppStrings.accountManagement,
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: tok.gap.lg),
              child: Divider(color: cs.outlineVariant, thickness: 0.8),
            ),
            _buildItem(
              context,
              AppStrings.editProfile,
              onTap: () => context.push(AppRoutes.editProfileScreen),
              showArrow: true,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: tok.gap.lg),
              child: Divider(color: cs.outlineVariant, thickness: 0.8),
            ),
            _buildItem(
              context,
              AppStrings.deleteYourAccount,
              onTap: () {
                // Handle Delete Account Logic
              },
              showArrow: true,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: tok.gap.lg),
              child: Divider(color: cs.outlineVariant, thickness: 0.8),
            ),
          ],
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

    return InkWell(
      onTap: onTap,
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
    );
  }
}
