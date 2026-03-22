import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lahal_application/features/profile/controller/edit_profile_controller.dart';
import 'package:lahal_application/features/profile/controller/profile_controller.dart';
import 'package:lahal_application/utils/components/appbar/internal_app_bar.dart';
import 'package:lahal_application/utils/components/image/app_circular_image.dart';
import 'package:lahal_application/utils/constants/app_svg.dart';
import 'package:lahal_application/utils/theme/app_button.dart';
import 'package:lahal_application/utils/components/textfields/customeTextField.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/components/shimmer/app_shimmer_effect.dart';
import 'package:lahal_application/features/profile/view/widgets/image_picker_bottom_sheet.dart';

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
      appBar: InternalAppBar(title: "Edit Profile", centerTitle: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: tok.gap.lg),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Photo Placeholder
                Center(
                      child: Stack(
                        children: [
                          Obx(
                            () => AppCircularImage(
                              image: controller.pickedImage.value != null
                                  ? ""
                                  : Get.find<ProfileController>()
                                            .userProfile
                                            .value
                                            ?.profilePhoto ??
                                        '',
                              isNetworkImage:
                                  controller.pickedImage.value == null,
                              imageFile: controller.pickedImage.value,
                              backgroundColor: cs.primaryContainer.withOpacity(
                                0.2,
                              ),
                            ),
                          ),
                          Obx(
                            () => controller.isLoading.value
                                ? Positioned.fill(
                                    child: AppShimerEffect(
                                      width:
                                          MediaQuery.sizeOf(context).width *
                                          0.24,
                                      height:
                                          MediaQuery.sizeOf(context).width *
                                          0.24,
                                      radius: 100,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () => ImagePickerBottomSheet.show(
                                context,
                                onGalleryTap: () {
                                  context.pop();
                                  controller.pickImage(ImageSource.gallery);
                                },
                                onCameraTap: () {
                                  context.pop();
                                  controller.pickImage(ImageSource.camera);
                                },
                                onRemoveTap: () {
                                  context.pop();
                                  controller.removeImage();
                                },
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: SvgPicture.asset(AppSvg.pencilIcon),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .scale(duration: 400.ms, curve: Curves.easeOutBack)
                    .fadeIn(),
                SizedBox(height: tok.gap.xl),

                // Name Field
                _buildLabel(
                  AppStrings.name,
                  tx,
                  tok,
                ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.1, end: 0),
                NewMyTextFeild(
                  controller: controller.nameController,
                  hintText: AppStrings.name,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Name is required'
                      : null,
                ).animate().fadeIn(delay: 150.ms).slideX(begin: 0.1, end: 0),
                SizedBox(height: tok.gap.md),

                // Phone Number Field (Disabled)
                _buildLabel(
                  AppStrings.phoneNumberLabelSmall,
                  tx,
                  tok,
                ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1, end: 0),
                NewMyTextFeild(
                  controller: controller.phoneController,
                  hintText: AppStrings.phoneNumberLabelSmall,
                  keyboardType: TextInputType.phone,
                  typingEnabled: false, // Number is not editable
                ).animate().fadeIn(delay: 250.ms).slideX(begin: 0.1, end: 0),
                SizedBox(height: tok.gap.md),

                // Email Field
                _buildLabel(
                  AppStrings.emailAddress,
                  tx,
                  tok,
                ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1, end: 0),
                NewMyTextFeild(
                  controller: controller.emailController,
                  hintText: AppStrings.emailAddress,
                  typingEnabled: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Email is required';
                    if (!GetUtils.isEmail(value)) return 'Enter a valid email';
                    return null;
                  },
                ).animate().fadeIn(delay: 350.ms).slideX(begin: 0.1, end: 0),
                SizedBox(height: tok.gap.md),

                // DOB Field
                _buildLabel(
                  AppStrings.dateOfBirth,
                  tx,
                  tok,
                ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1, end: 0),
                GestureDetector(
                  onTap: () => controller.pickDate(context),
                  child: AbsorbPointer(
                    child: NewMyTextFeild(
                      controller: controller.dobController,
                      hintText: AppStrings.dobHint,
                      validator: (value) => value == null || value.isEmpty
                          ? 'DOB is required'
                          : null,
                    ),
                  ),
                ).animate().fadeIn(delay: 450.ms).slideX(begin: 0.1, end: 0),
                SizedBox(height: tok.gap.md),

                // Gender Field
                _buildLabel(
                  AppStrings.gender,
                  tx,
                  tok,
                ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1, end: 0),
                Obx(
                  () => Column(
                    children: [
                      GestureDetector(
                        onTap: controller.toggleGenderExpanded,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: tok.gap.xs,
                            vertical: tok.gap.xs,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline,
                              width: 1.4,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                controller.selectedGender.value.isEmpty
                                    ? AppStrings.select
                                    : controller
                                          .selectedGender
                                          .value
                                          .capitalizeFirst!,
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: controller.genderOptions.map((gender) {
                              return ListTile(
                                title: AppText(
                                  gender.capitalizeFirst!,
                                  size: AppTextSize.s14,
                                ),
                                onTap: () => controller.selectGender(gender),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                ).animate().fadeIn(delay: 550.ms).slideX(begin: 0.1, end: 0),
                SizedBox(height: tok.gap.xxl),

                // Save Button
                Obx(
                      () => AppButton(
                        radiusOverride: 12,
                        loading: controller.isLoading.value,
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.saveProfile(context),
                        label: AppStrings.save,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 600.ms)
                    .scale(begin: const Offset(0.9, 0.9)),
                SizedBox(height: tok.gap.xl),
              ],
            ),
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
