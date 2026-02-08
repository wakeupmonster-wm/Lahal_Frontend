import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/features/profile/controller/edit_profile_controller.dart';
import 'package:lahal_application/utils/components/appbar/internal_app_bar.dart';
import 'package:lahal_application/utils/theme/app_button.dart';
import 'package:lahal_application/utils/components/textfields/customeTextField.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/constants/app_colors.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: InternalAppBar(title: "", centerTitle: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: tok.gap.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Photo Placeholder
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: cs.primaryContainer.withOpacity(0.2),
                      child: AppText(
                        'U',
                        size: AppTextSize.s24,
                        weight: AppTextWeight.medium,
                        color: tx.primary,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Icon(Icons.edit_outlined, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: tok.gap.xl),

              // Name Field
              _buildLabel(AppStrings.name, tx, tok),
              MyTextFeild(
                controller: controller.nameController,
                hintText: AppStrings.name,
              ),
              SizedBox(height: tok.gap.md),

              // Phone Number Field
              _buildLabel(AppStrings.phoneNumberLabelSmall, tx, tok),
              Obx(
                () => MyTextFeild(
                  controller: controller.phoneController,
                  hintText: AppStrings.phoneNumberLabelSmall,
                  typingEnabled: controller.isPhoneEditable.value,
                  suffix: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextButton(
                      onPressed: controller.togglePhoneEditable,
                      child: AppText(
                        AppStrings.change,
                        size: AppTextSize.s12,
                        weight: AppTextWeight.bold,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: tok.gap.md),

              // Email Field
              _buildLabel(AppStrings.emailAddress, tx, tok),
              Obx(
                () => MyTextFeild(
                  controller: controller.emailController,
                  hintText: AppStrings.emailAddress,
                  typingEnabled: controller.isEmailEditable.value,
                  suffix: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextButton(
                      onPressed: controller.toggleEmailEditable,
                      child: AppText(
                        AppStrings.change,
                        size: AppTextSize.s12,
                        weight: AppTextWeight.bold,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: tok.gap.md),

              // DOB Field
              _buildLabel(AppStrings.dateOfBirth, tx, tok),
              GestureDetector(
                onTap: () => controller.pickDate(context),
                child: AbsorbPointer(
                  child: MyTextFeild(
                    controller: controller.dobController,
                    hintText: AppStrings.dobHint,
                  ),
                ),
              ),
              SizedBox(height: tok.gap.md),

              // Gender Field
              _buildLabel(AppStrings.gender, tx, tok),
              Obx(
                () => Column(
                  children: [
                    GestureDetector(
                      onTap: controller.toggleGenderExpanded,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: tok.gap.md,
                          vertical: tok.gap.sm,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColor.primaryColor1,
                            width: 1.4,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              controller.selectedGender.value.isEmpty
                                  ? AppStrings.select
                                  : controller.selectedGender.value,
                              size: AppTextSize.s14,
                              color: controller.selectedGender.value.isEmpty
                                  ? tx.primary.withOpacity(0.5)
                                  : tx.primary,
                            ),
                            Icon(
                              controller.isGenderExpanded.value
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (controller.isGenderExpanded.value)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          children: controller.genderOptions.map((gender) {
                            return ListTile(
                              title: AppText(gender, size: AppTextSize.s14),
                              onTap: () => controller.selectGender(gender),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: tok.gap.xxl),

              // Save Button
              Obx(
                () => AppButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.saveProfile(context),
                  label: AppStrings.save,
                ),
              ),
              SizedBox(height: tok.gap.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, AppTextColors tx, AppTokens tok) {
    return Padding(
      padding: EdgeInsets.only(bottom: tok.gap.xs),
      child: AppText(
        text,
        size: AppTextSize.s14,
        weight: AppTextWeight.bold,
        color: tx.primary,
      ),
    );
  }
}
