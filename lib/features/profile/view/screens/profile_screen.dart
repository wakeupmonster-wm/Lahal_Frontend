import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lahal_application/utils/constants/app_colors.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/constants/app_svg.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: tok.gap.lg,
            vertical: tok.gap.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: tok.gap.xs),
              // --- Profile Header ---
              CircleAvatar(
                radius: 40,
                backgroundColor: cs.primaryContainer.withOpacity(0.2),
                child: AppText(
                  'U',
                  size: AppTextSize.s24,
                  weight: AppTextWeight.medium,
                  color: tx.primary,
                ),
              ),
              SizedBox(height: tok.gap.md),
              AppText(
                'User225',
                size: AppTextSize.s24,
                weight: AppTextWeight.bold,
                color: tx.neutral,
              ),
              SizedBox(height: tok.gap.xs),
              GestureDetector(
                onTap: () {},
                child: AppText(
                  AppStrings.editProfile,
                  size: AppTextSize.s14,
                  weight: AppTextWeight.medium,
                  color: AppColor.primaryColor,
                ),
              ),
              SizedBox(height: tok.gap.md),

              // --- Account Section ---
              _buildSectionTitle(tx, AppStrings.account, tok),
              _buildSectionContainer(cs, [
                _buildProfileItem(
                  context,
                  tok,
                  tx,
                  cs,
                  svgIcon: AppSvg.heartIcon,
                  label: AppStrings.favorites,
                ),
                _buildProfileItem(
                  context,
                  tok,
                  tx,
                  cs,
                  svgIcon: AppSvg.locationIcon,
                  label: AppStrings.changeLocation,
                ),
              ], tok),
              SizedBox(height: tok.gap.xs),

              // --- Settings Section ---
              _buildSectionTitle(tx, AppStrings.settings, tok),
              _buildSectionContainer(cs, [
                _buildProfileItem(
                  context,
                  tok,
                  tx,
                  cs,
                  svgIcon: AppSvg.notificationIcon,
                  label: AppStrings.notificationPreferences,
                ),
                _buildProfileItem(
                  context,
                  tok,
                  tx,
                  cs,
                  svgIcon: AppSvg.accountIcon,
                  label: AppStrings.accountSettings,
                ),
              ], tok),
              SizedBox(height: tok.gap.xs),

              // --- Legal Section ---
              _buildSectionTitle(tx, AppStrings.legal, tok),
              _buildSectionContainer(cs, [
                _buildProfileItem(
                  context,
                  tok,
                  tx,
                  cs,
                  svgIcon: AppSvg.faqIcon,
                  label: AppStrings.faqs,
                ),
                _buildProfileItem(
                  context,
                  tok,
                  tx,
                  cs,
                  svgIcon: AppSvg.aboutIcon,
                  label: AppStrings.about,
                ),
              ], tok),
              SizedBox(height: tok.gap.xs),

              // --- Logout Section ---
              _buildSectionTitle(tx, AppStrings.logout, tok),
              _buildSectionContainer(cs, [
                _buildProfileItem(
                  context,
                  tok,
                  tx,
                  cs,
                  svgIcon: AppSvg.logoutIcon,
                  label: AppStrings.logout,
                  isLast: true,
                ),
              ], tok),
              SizedBox(height: tok.gap.xxl),
              SizedBox(height: tok.gap.xxl),
              SizedBox(height: tok.gap.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(AppTextColors tx, String title, AppTokens tok) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: tok.gap.xxs,
          vertical: tok.gap.xxs,
        ),
        child: AppText(
          title,
          size: AppTextSize.s14,
          weight: AppTextWeight.semibold,
          color: tx.subtle,
        ),
      ),
    );
  }

  Widget _buildSectionContainer(
    ColorScheme cs,
    List<Widget> children,
    AppTokens tok,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(tok.radiusMd),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildProfileItem(
    BuildContext context,
    AppTokens tok,
    AppTextColors tx,
    ColorScheme cs, {
    required String svgIcon,
    required String label,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: tok.gap.md,
          vertical: tok.gap.xs,
        ),
        child: Row(
          children: [
            SvgPicture.asset(svgIcon),
            SizedBox(width: tok.gap.md),
            Expanded(
              child: AppText(
                label,
                size: AppTextSize.s16,
                weight: AppTextWeight.semibold,
                color: tx.primary,
              ),
            ),
            SvgPicture.asset(AppSvg.rightArrowIcon, color: tx.primary),
          ],
        ),
      ),
    );
  }
}
