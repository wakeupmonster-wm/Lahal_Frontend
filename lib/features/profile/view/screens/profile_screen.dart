import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/utils/components/image/app_circular_image.dart';
import 'package:lahal_application/utils/constants/app_colors.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/constants/app_svg.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:get/get.dart';
import 'package:lahal_application/features/profile/controller/profile_controller.dart';
import 'package:lahal_application/features/profile/view/widgets/logout_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
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
              AppCircularImage(
                image:
                    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
                isNetworkImage: true,
                backgroundColor: cs.primaryContainer.withOpacity(0.2),
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
                onTap: () => context.push(AppRoutes.editProfileScreen),
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
                  controller,
                  context,
                  tok,
                  tx,
                  cs,
                  svgIcon: AppSvg.heartIcon,
                  label: AppStrings.favorites,
                ),
                _buildProfileItem(
                  controller,
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
                  controller,
                  context,
                  tok,
                  tx,
                  cs,
                  svgIcon: AppSvg.bluenotificationIcon,
                  label: AppStrings.notificationPreferences,
                ),
                _buildProfileItem(
                  controller,
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
                  controller,
                  context,
                  tok,
                  tx,
                  cs,
                  svgIcon: AppSvg.faqIcon,
                  label: AppStrings.faqs,
                ),
                _buildProfileItem(
                  controller,
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
                  controller,
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
    ProfileController controller,
    BuildContext context,
    AppTokens tok,
    AppTextColors tx,
    ColorScheme cs, {
    required String svgIcon,
    required String label,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: () {
        if (label == AppStrings.about) {
          context.push(AppRoutes.aboutScreen);
        } else if (label == AppStrings.faqs) {
          context.push(AppRoutes.faqScreen);
        } else if (label == AppStrings.accountSettings) {
          context.push(AppRoutes.accountManagement);
        } else if (label == AppStrings.changeLocation) {
          context.push(AppRoutes.changeLocationScreen);
        } else if (label == AppStrings.notificationPreferences) {
          context.push(AppRoutes.notificationPreferenceScreen);
        } else if (label == AppStrings.favorites) {
          context.push(AppRoutes.favoritesScreen);
        } else if (label == AppStrings.logout) {
          showDialog(
            context: context,
            builder: (context) => LogoutDialog(
              onConfirm: () {
                context.pop();
                controller.logout(context);
              },
            ),
          );
        }
      },
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
