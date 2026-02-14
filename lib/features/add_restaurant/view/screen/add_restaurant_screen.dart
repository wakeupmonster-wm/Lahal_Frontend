import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lahal_application/utils/constants/app_assets.dart';
import 'package:lahal_application/utils/constants/app_colors.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/components/textfields/app_text_field.dart';
import '../../controller/add_restaurant_controller.dart';
import '../widget/add_restaurant_widgets.dart';

class AddRestaurantScreen extends StatelessWidget {
  const AddRestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddRestaurantController());
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image Background
            Stack(
              children: [
                Image.asset(
                  AppAssets.biryaniImage,
                  width: double.infinity,
                  height: 280,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 80,
                  left: tok.gap.md,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        "Help the Community",
                        size: AppTextSize.s24,
                        weight: AppTextWeight.bold,
                        colorToken: tx.neutral,
                      ),
                      AppText(
                        "Discover LaLah",
                        size: AppTextSize.s24,
                        weight: AppTextWeight.bold,
                        colorToken: tx.neutral,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(tok.gap.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Name
                  const FormLabel(label: "Restaurant name"),
                  AppTextField(
                    controller: controller.restaurantNameController,
                    hintText: "Hamza food court",
                    isOutline: true,
                  ),
                  SizedBox(height: tok.gap.md),

                  // Address
                  const FormLabel(label: "Address"),
                  AppTextField(
                    controller: controller.addressController,
                    hintText: "Full restaurant address",
                    isOutline: true,
                  ),
                  SizedBox(height: tok.gap.md),

                  // City
                  const FormLabel(label: "City"),
                  AppTextField(
                    controller: controller.cityController,
                    hintText: "City",
                    isOutline: true,
                  ),
                  SizedBox(height: tok.gap.md),

                  // Halal Status
                  const FormLabel(label: "Halal Status"),
                  Obx(
                    () => Column(
                      children: controller.halalStatuses.map((status) {
                        return RadioListTile<String>(
                          title: AppText(
                            status,
                            size: AppTextSize.s14,
                            weight: AppTextWeight.medium,
                            colorToken: tx.neutral,
                          ),
                          value: status,
                          groupValue: controller.selectedHalalStatus.value,
                          onChanged: (value) {
                            if (value != null) controller.setHalalStatus(value);
                          },
                          contentPadding: EdgeInsets.zero,
                          activeColor: AppColor.primaryColor,
                          dense: true,
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: tok.gap.md),

                  // Add Restaurant Photos
                  const FormLabel(label: "Add restaurant photos"),
                  Obx(
                    () => SizedBox(
                      height: 110,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...controller.selectedImages.asMap().entries.map((
                            entry,
                          ) {
                            return ImagePickerTile(
                              image: entry.value,
                              onTap: () {},
                              onRemove: () => controller.removeImage(entry.key),
                            );
                          }).toList(),
                          ImagePickerTile(
                            isAddButton: true,
                            onTap: controller.pickImages,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: tok.gap.md),

                  // Additional Note
                  const FormLabel(label: "Additional Note"),
                  AppTextField(
                    controller: controller.additionalNoteController,
                    hintText: "Any helpful detail",
                    isOutline: true,
                    maxLines: 4,
                  ),
                  SizedBox(height: tok.gap.lg),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: controller.clearForm,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: cs.outline),
                            padding: EdgeInsets.symmetric(vertical: tok.gap.md),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(tok.radiusMd),
                            ),
                          ),
                          child: AppText(
                            "Cancel",
                            size: AppTextSize.s16,
                            weight: AppTextWeight.semibold,
                            colorToken: tx.neutral,
                          ),
                        ),
                      ),
                      SizedBox(width: tok.gap.md),
                      Expanded(
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.submitRequest,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primaryColor,
                              padding: EdgeInsets.symmetric(
                                vertical: tok.gap.md,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  tok.radiusMd,
                                ),
                              ),
                            ),
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : AppText(
                                    "Send Request",
                                    size: AppTextSize.s16,
                                    weight: AppTextWeight.semibold,
                                    colorToken: tx.inverse,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: tok.gap.xxl), // Bottom padding for footer
                  SizedBox(height: tok.gap.xxl),
                  SizedBox(height: tok.gap.xxl),
                  SizedBox(height: tok.gap.xxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
