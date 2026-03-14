import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lahal_application/utils/constants/app_assets.dart';
import 'package:lahal_application/utils/constants/app_colors.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/components/textfields/app_text_field.dart';
import 'package:lahal_application/utils/components/widgets/app_footer.dart';
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
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image Background
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(tok.radiusLg * 2),
                    bottomRight: Radius.circular(tok.radiusLg * 2),
                  ),
                  child: Image.asset(
                    AppAssets.addResturentBanner,
                    width: double.infinity,
                    height: height * 0.3,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: height * 0.086,
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
                            weight: AppTextWeight.semibold,
                            colorToken: tx.neutral,
                          ),
                          value: status,
                          groupValue: controller.selectedHalalStatus.value,
                          onChanged: (value) {
                            if (value != null) controller.setHalalStatus(value);
                          },
                          contentPadding: EdgeInsets.zero,
                          visualDensity: const VisualDensity(
                            horizontal: 0,
                            vertical: -1,
                          ),
                          fillColor: MaterialStateProperty.resolveWith<Color>((
                            states,
                          ) {
                            if (states.contains(MaterialState.selected)) {
                              return AppColor.primaryColor;
                            }
                            return AppColor.grey.withOpacity(0.4);
                          }),
                          dense: true,
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: tok.gap.md),

                  // Add Restaurant Photos
                  const FormLabel(label: "Add restaurant photos"),
                  SizedBox(height: tok.gap.xs),
                  Obx(
                    () => GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      clipBehavior: Clip.none,
                      padding: EdgeInsets.only(top: tok.gap.xs),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: tok.gap.sm,
                        mainAxisSpacing: tok.gap.sm,
                        mainAxisExtent: height * 0.118,
                      ),
                      itemCount: controller.selectedImages.length + 1,
                      itemBuilder: (context, index) {
                        if (index < controller.selectedImages.length) {
                          return ImagePickerTile(
                            image: controller.selectedImages[index],
                            onTap: () {},
                            onRemove: () => controller.removeImage(index),
                          );
                        } else {
                          return ImagePickerTile(
                            isAddButton: true,
                            onTap: controller.pickImages,
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: tok.gap.md),

                  // Additional Note
                  const FormLabel(label: "Additional Note"),
                  SizedBox(height: tok.gap.xs),
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
                            padding: EdgeInsets.symmetric(vertical: tok.gap.sm),
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
                                vertical: tok.gap.sm,
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
                ],
              ),
            ),
            // Footer
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}
















// //--------------this is an scroll down bottm bar code 
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:get/get.dart';
// import 'package:lahal_application/features/bottomNavigationBar/controller/bottom_navigationbar_controller.dart';
// import 'package:lahal_application/utils/constants/app_assets.dart';
// import 'package:lahal_application/utils/constants/app_colors.dart';
// import 'package:lahal_application/utils/theme/app_tokens.dart';
// import 'package:lahal_application/utils/theme/text/app_text_color.dart';
// import 'package:lahal_application/utils/theme/text/app_text.dart';
// import 'package:lahal_application/utils/theme/text/app_typography.dart';
// import 'package:lahal_application/utils/components/textfields/app_text_field.dart';
// import 'package:lahal_application/utils/components/widgets/app_footer.dart';
// import '../../controller/add_restaurant_controller.dart';
// import '../widget/add_restaurant_widgets.dart';

// class AddRestaurantScreen extends StatefulWidget {
//   const AddRestaurantScreen({super.key});

//   @override
//   State<AddRestaurantScreen> createState() => _AddRestaurantScreenState();
// }

// class _AddRestaurantScreenState extends State<AddRestaurantScreen> {
//   late final ScrollController scrollController;

//   @override
//   void initState() {
//     super.initState();
//     scrollController = ScrollController();
//     scrollController.addListener(() {
//       final bottomNavController = Get.find<BottomNavController>();
//       if (scrollController.position.userScrollDirection ==
//           ScrollDirection.reverse) {
//         bottomNavController.setNavBarVisible(false);
//       } else if (scrollController.position.userScrollDirection ==
//           ScrollDirection.forward) {
//         bottomNavController.setNavBarVisible(true);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(AddRestaurantController());
//     final tok = Theme.of(context).extension<AppTokens>()!;
//     final tx = Theme.of(context).extension<AppTextColors>()!;
//     final cs = Theme.of(context).colorScheme;
//     final mediaQuery = MediaQuery.of(context);
//     final height = mediaQuery.size.height;

//     return Scaffold(
//       backgroundColor: cs.surface,
//       body: SingleChildScrollView(
//         controller: scrollController,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Image Background
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(tok.radiusLg * 2),
//                     bottomRight: Radius.circular(tok.radiusLg * 2),
//                   ),
//                   child: Image.asset(
//                     AppAssets.addResturentBanner,
//                     width: double.infinity,
//                     height: height * 0.3,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Positioned(
//                   top: height * 0.086,
//                   left: tok.gap.md,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppText(
//                         "Help the Community",
//                         size: AppTextSize.s24,
//                         weight: AppTextWeight.bold,
//                         colorToken: tx.neutral,
//                       ),
//                       AppText(
//                         "Discover LaLah",
//                         size: AppTextSize.s24,
//                         weight: AppTextWeight.bold,
//                         colorToken: tx.neutral,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             Padding(
//               padding: EdgeInsets.all(tok.gap.md),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Restaurant Name
//                   const FormLabel(label: "Restaurant name"),
//                   AppTextField(
//                     controller: controller.restaurantNameController,
//                     hintText: "Hamza food court",
//                     isOutline: true,
//                   ),
//                   SizedBox(height: tok.gap.md),

//                   // Address
//                   const FormLabel(label: "Address"),

//                   AppTextField(
//                     controller: controller.addressController,
//                     hintText: "Full restaurant address",
//                     isOutline: true,
//                   ),
//                   SizedBox(height: tok.gap.md),

//                   // City
//                   const FormLabel(label: "City"),
//                   AppTextField(
//                     controller: controller.cityController,
//                     hintText: "City",
//                     isOutline: true,
//                   ),
//                   SizedBox(height: tok.gap.md),

//                   // Halal Status
//                   const FormLabel(label: "Halal Status"),
//                   Obx(
//                     () => Column(
//                       children: controller.halalStatuses.map((status) {
//                         return RadioListTile<String>(
//                           title: AppText(
//                             status,
//                             size: AppTextSize.s14,
//                             weight: AppTextWeight.semibold,
//                             colorToken: tx.neutral,
//                           ),
//                           value: status,
//                           groupValue: controller.selectedHalalStatus.value,
//                           onChanged: (value) {
//                             if (value != null) controller.setHalalStatus(value);
//                           },
//                           contentPadding: EdgeInsets.zero,
//                           visualDensity: const VisualDensity(
//                             horizontal: 0,
//                             vertical: -1,
//                           ),
//                           fillColor: MaterialStateProperty.resolveWith<Color>((
//                             states,
//                           ) {
//                             if (states.contains(MaterialState.selected)) {
//                               return AppColor.primaryColor;
//                             }
//                             return AppColor.grey.withOpacity(0.4);
//                           }),
//                           dense: true,
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                   SizedBox(height: tok.gap.md),

//                   // Add Restaurant Photos
//                   const FormLabel(label: "Add restaurant photos"),
//                   SizedBox(height: tok.gap.xs),
//                   Obx(
//                     () => GridView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       clipBehavior: Clip.none,
//                       padding: EdgeInsets.only(top: tok.gap.xs),
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3,
//                         crossAxisSpacing: tok.gap.sm,
//                         mainAxisSpacing: tok.gap.sm,
//                         mainAxisExtent: height * 0.118,
//                       ),
//                       itemCount: controller.selectedImages.length + 1,
//                       itemBuilder: (context, index) {
//                         if (index < controller.selectedImages.length) {
//                           return ImagePickerTile(
//                             image: controller.selectedImages[index],
//                             onTap: () {},
//                             onRemove: () => controller.removeImage(index),
//                           );
//                         } else {
//                           return ImagePickerTile(
//                             isAddButton: true,
//                             onTap: controller.pickImages,
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                   SizedBox(height: tok.gap.md),

//                   // Additional Note
//                   const FormLabel(label: "Additional Note"),
//                   SizedBox(height: tok.gap.xs),
//                   AppTextField(
//                     controller: controller.additionalNoteController,
//                     hintText: "Any helpful detail",
//                     isOutline: true,
//                     maxLines: 4,
//                   ),
//                   SizedBox(height: tok.gap.lg),

//                   // Buttons
//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: controller.clearForm,
//                           style: OutlinedButton.styleFrom(
//                             side: BorderSide(color: cs.outline),
//                             padding: EdgeInsets.symmetric(vertical: tok.gap.sm),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(tok.radiusMd),
//                             ),
//                           ),
//                           child: AppText(
//                             "Cancel",
//                             size: AppTextSize.s16,
//                             weight: AppTextWeight.semibold,
//                             colorToken: tx.neutral,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: tok.gap.md),
//                       Expanded(
//                         child: Obx(
//                           () => ElevatedButton(
//                             onPressed: controller.isLoading.value
//                                 ? null
//                                 : controller.submitRequest,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColor.primaryColor,
//                               padding: EdgeInsets.symmetric(
//                                 vertical: tok.gap.sm,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(
//                                   tok.radiusMd,
//                                 ),
//                               ),
//                             ),
//                             child: controller.isLoading.value
//                                 ? const CircularProgressIndicator(
//                                     color: Colors.white,
//                                   )
//                                 : AppText(
//                                     "Send Request",
//                                     size: AppTextSize.s16,
//                                     weight: AppTextWeight.semibold,
//                                     colorToken: tx.inverse,
//                                   ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             // Footer
//             const AppFooter(),
//           ],
//         ),
//       ),
//     );
//   }
// }
