import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lahal_application/utils/components/appbar/internal_app_bar.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/constants/app_svg.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/features/profile/view/widgets/confirmation_bottom_sheet.dart';
import 'package:lahal_application/features/profile/controller/account_management_controller.dart';
import 'package:get/get.dart';

class AccountManagementScreen extends StatelessWidget {
  const AccountManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AccountManagementController());
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerHighest.withValues(
        alpha: 3,
      ), // Light fade effect
      appBar: InternalAppBar(
        title: AppStrings.accountManagement,
        centerTitle: false,
        backgroundColor: cs.surface,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // const SizedBox(height: 20),
            Container(
              color: cs.surface, // Pure white/dark surface
              child: Column(
                children: [
                  // _buildItem(
                  //   context,
                  //   AppStrings.editProfile,
                  //   onTap: () => context.push(AppRoutes.editProfileScreen),
                  //   showArrow: true,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: Divider(
                  //     color: cs.outlineVariant.withValues(alpha: 0.5),
                  //     thickness: 0.8,
                  //     height: 1,
                  //   ),
                  // ),
                  _buildItem(
                    context,
                    AppStrings.deleteYourAccount,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Obx(
                          () => ConfirmationBottomSheet(
                            title: AppStrings.wantToDeleteAccount,
                            subtitle: AppStrings.deleteAccountConfirmation,
                            confirmLabel: AppStrings.delete,
                            onConfirm: () => controller.deleteAccount(context),
                            loading: controller.isLoading.value,
                          ),
                        ),
                      );
                    },
                    showArrow: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      color: cs.outlineVariant.withValues(alpha: 0.5),
                      thickness: 0.8,
                      height: 1,
                    ),
                  ),
                ],
              ),
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
              SvgPicture.asset(
                AppSvg.rightArrowIcon,
                colorFilter: ColorFilter.mode(tx.primary, BlendMode.srcIn),
              ),
          ],
        ),
      ),
    );
  }
}
