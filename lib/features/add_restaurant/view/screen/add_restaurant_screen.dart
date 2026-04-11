import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lahal_application/utils/constants/app_assets.dart';
import 'package:lahal_application/utils/constants/app_colors.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/components/textfields/app_text_field.dart';
import 'package:lahal_application/utils/components/widgets/app_footer.dart';
import '../../controller/add_restaurant_controller.dart';
import 'package:lahal_application/features/bottomNavigationBar/controller/bottom_navigationbar_controller.dart';
import '../widget/add_restaurant_widgets.dart';

import 'package:lahal_application/utils/components/widgets/app_scroll_indicator.dart';

class AddRestaurantScreen extends StatefulWidget {
  const AddRestaurantScreen({super.key});

  @override
  State<AddRestaurantScreen> createState() => _AddRestaurantScreenState();
}

class _AddRestaurantScreenState extends State<AddRestaurantScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
      body: Obx(() {
        final bottomNavController = Get.find<BottomNavController>();
        final isSelected = bottomNavController.selectedIndex.value == 1;

        return KeyedSubtree(
          key: ValueKey('add_restaurant_active_$isSelected'),
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: Obx(
                  () => Form(
                    key: controller.formKey,
                    autovalidateMode: controller.autovalidateMode.value,
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
                                      )
                                      .animate()
                                      .fadeIn(duration: 600.ms)
                                      .slideX(begin: -0.2, end: 0),
                                  AppText(
                                        "Discover LaLah",
                                        size: AppTextSize.s24,
                                        weight: AppTextWeight.bold,
                                        colorToken: tx.neutral,
                                      )
                                      .animate()
                                      .fadeIn(duration: 600.ms, delay: 200.ms)
                                      .slideX(begin: -0.2, end: 0),
                                ],
                              ),
                            ),
                          ],
                        ).animate().fadeIn().slideY(begin: -0.1, end: 0),

                        Padding(
                          padding: EdgeInsets.all(tok.gap.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...[
                                    // Restaurant Name
                                    const FormLabel(label: "Restaurant name"),
                                    AppTextField(
                                      controller:
                                          controller.restaurantNameController,
                                      hintText: "Hamza food court",
                                      isOutline: true,
                                      validator: (value) =>
                                          value == null || value.trim().isEmpty
                                          ? 'Restaurant name is required'
                                          : null,
                                    ),
                                    SizedBox(height: tok.gap.md),
                                  ]
                                  .animate(interval: 50.ms)
                                  .fadeIn(delay: 300.ms)
                                  .slideX(begin: 0.1, end: 0),

                              ...[
                                    // Address
                                    const FormLabel(label: "Address"),

                                    AppTextField(
                                      controller: controller.addressController,
                                      hintText: "Full restaurant address",
                                      isOutline: true,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Address is required';
                                        }
                                        if (value.trim().length < 10) {
                                          return 'Address must be at least 10 characters long';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: tok.gap.md),
                                  ]
                                  .animate(interval: 50.ms)
                                  .fadeIn(delay: 400.ms)
                                  .slideX(begin: 0.1, end: 0),

                              ...[
                                    // City
                                    const FormLabel(label: "City"),
                                    AppTextField(
                                      controller: controller.cityController,
                                      hintText: "City",
                                      isOutline: true,
                                      validator: (value) =>
                                          value == null || value.trim().isEmpty
                                          ? 'City is required'
                                          : null,
                                    ),
                                    SizedBox(height: tok.gap.md),
                                  ]
                                  .animate(interval: 50.ms)
                                  .fadeIn(delay: 500.ms)
                                  .slideX(begin: 0.1, end: 0),

                              ...[
                                    // State
                                    const FormLabel(label: "State"),
                                    AppTextField(
                                      controller: controller.stateController,
                                      hintText: "State",
                                      isOutline: true,
                                      validator: (value) =>
                                          value == null || value.trim().isEmpty
                                          ? 'State is required'
                                          : null,
                                    ),
                                    SizedBox(height: tok.gap.md),
                                  ]
                                  .animate(interval: 50.ms)
                                  .fadeIn(delay: 600.ms)
                                  .slideX(begin: 0.1, end: 0),

                              ...[
                                    // Country
                                    const FormLabel(label: "Country"),
                                    AppTextField(
                                      controller: controller.countryController,
                                      hintText: "Country",
                                      isOutline: true,
                                      validator: (value) =>
                                          value == null || value.trim().isEmpty
                                          ? 'Country is required'
                                          : null,
                                    ),
                                    SizedBox(height: tok.gap.md),
                                  ]
                                  .animate(interval: 50.ms)
                                  .fadeIn(delay: 700.ms)
                                  .slideX(begin: 0.1, end: 0),

                              ...[
                                    // Pincode
                                    const FormLabel(label: "Pincode"),
                                    AppTextField(
                                      controller: controller.pincodeController,
                                      hintText: "Pincode",
                                      isOutline: true,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Pincode is required';
                                        }
                                        if (value.length < 6) {
                                          return 'Enter a valid 6-digit pincode';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: tok.gap.md),
                                  ]
                                  .animate(interval: 50.ms)
                                  .fadeIn(delay: 800.ms)
                                  .slideX(begin: 0.1, end: 0),

                              ...[
                                    // Halal Status
                                    const FormLabel(label: "Halal Status"),
                                    Obx(
                                      () => Column(
                                        children: controller.halalStatuses.map((
                                          status,
                                        ) {
                                          return RadioListTile<String>(
                                            title: AppText(
                                              status,
                                              size: AppTextSize.s14,
                                              weight: AppTextWeight.semibold,
                                              colorToken: tx.neutral,
                                            ),
                                            value: status,
                                            groupValue: controller
                                                .selectedHalalStatus
                                                .value,
                                            onChanged: (value) {
                                              if (value != null) {
                                                controller.setHalalStatus(
                                                  value,
                                                );
                                              }
                                            },
                                            contentPadding: EdgeInsets.zero,
                                            visualDensity: const VisualDensity(
                                              horizontal: 0,
                                              vertical: -1,
                                            ),
                                            fillColor:
                                                WidgetStateProperty.resolveWith<
                                                  Color
                                                >((states) {
                                                  if (states.contains(
                                                    WidgetState.selected,
                                                  )) {
                                                    return AppColor
                                                        .primaryColor;
                                                  }
                                                  return AppColor.grey
                                                      .withOpacity(0.4);
                                                }),
                                            dense: true,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    SizedBox(height: tok.gap.md),
                                  ]
                                  .animate(interval: 50.ms)
                                  .fadeIn(delay: 900.ms)
                                  .slideX(begin: 0.1, end: 0),

                              ...[
                                    // Add Restaurant Photos
                                    const FormLabel(
                                      label: "Add restaurant photos",
                                    ),
                                    SizedBox(height: tok.gap.xs),
                                    Obx(
                                      () => GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        clipBehavior: Clip.none,
                                        padding: EdgeInsets.only(
                                          top: tok.gap.xs,
                                        ),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: tok.gap.sm,
                                              mainAxisSpacing: tok.gap.sm,
                                              mainAxisExtent: height * 0.118,
                                            ),
                                        itemCount:
                                            controller.selectedImages.length +
                                            1,
                                        itemBuilder: (context, index) {
                                          if (index <
                                              controller
                                                  .selectedImages
                                                  .length) {
                                            return ImagePickerTile(
                                                  image: controller
                                                      .selectedImages[index],
                                                  onTap: () {},
                                                  onRemove: () => controller
                                                      .removeImage(index),
                                                )
                                                .animate()
                                                .fadeIn(delay: (index * 50).ms)
                                                .scale(
                                                  begin: const Offset(0.8, 0.8),
                                                );
                                          } else {
                                            return ImagePickerTile(
                                                  isAddButton: true,
                                                  onTap: controller.pickImages,
                                                )
                                                .animate()
                                                .fadeIn(delay: (index * 50).ms)
                                                .scale(
                                                  begin: const Offset(0.8, 0.8),
                                                );
                                          }
                                        },
                                      ),
                                    ),
                                    Obx(() {
                                      if (controller
                                          .selectedImagesError
                                          .value
                                          .isNotEmpty) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            top: tok.gap.xs,
                                          ),
                                          child: AppText(
                                            controller
                                                .selectedImagesError
                                                .value,
                                            size: AppTextSize.s12,
                                            colorToken: tx.error,
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    }),
                                    SizedBox(height: tok.gap.md),
                                  ]
                                  .animate(interval: 50.ms)
                                  .fadeIn(delay: 1000.ms)
                                  .slideX(begin: 0.1, end: 0),

                              ...[
                                    // Additional Note
                                    const FormLabel(label: "Additional Note"),
                                    AppTextField(
                                      controller:
                                          controller.additionalNoteController,
                                      hintText: "Any helpful detail",
                                      isOutline: true,
                                      maxLines: 4,
                                      validator: (value) =>
                                          value == null || value.trim().isEmpty
                                          ? 'Additional note is required'
                                          : null,
                                    ),
                                    SizedBox(height: tok.gap.lg),
                                  ]
                                  .animate(interval: 50.ms)
                                  .fadeIn(delay: 1100.ms)
                                  .slideX(begin: 0.1, end: 0),

                              Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            HapticFeedback.mediumImpact();
                                            controller.clearForm();
                                          },
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(color: cs.outline),
                                            padding: EdgeInsets.symmetric(
                                              vertical: tok.gap.sm,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    tok.radiusMd,
                                                  ),
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
                                            onPressed: () {
                                              HapticFeedback.mediumImpact();
                                              controller.submitRequest();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColor.primaryColor,
                                              padding: EdgeInsets.symmetric(
                                                vertical: tok.gap.sm,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      tok.radiusMd,
                                                    ),
                                              ),
                                            ),
                                            child: controller.isLoading.value
                                                ? const SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: Colors.white,
                                                          strokeWidth: 2,
                                                        ),
                                                  )
                                                : AppText(
                                                    "Send Request",
                                                    size: AppTextSize.s16,
                                                    weight:
                                                        AppTextWeight.semibold,
                                                    colorToken: tx.inverse,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                  .animate(delay: 1200.ms)
                                  .fadeIn()
                                  .scale(begin: const Offset(0.9, 0.9)),
                            ],
                          ),
                        ),
                        // Footer
                        const AppFooter(),
                      ],
                    ),
                  ),
                ),
              ),
              // Scroll Indicator
              Positioned(
                right: 4,
                top: 0,
                bottom: 0,
                child: AppScrollIndicator(controller: _scrollController),
              ),
            ],
          ),
        );
      }),
    );
  }
}



































//scroll indicator and button hide old code



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
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

// class AddRestaurantScreen extends StatelessWidget {
//   AddRestaurantScreen({super.key});

//   final ScrollController scrollController = ScrollController();

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(AddRestaurantController());
//     final tok = Theme.of(context).extension<AppTokens>()!;
//     final tx = Theme.of(context).extension<AppTextColors>()!;
//     final cs = Theme.of(context).colorScheme;
//     final mediaQuery = MediaQuery.of(context);
//     final height = mediaQuery.size.height;

//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: cs.surface,

//       body: Stack(
//         children: [
//           // 🔥 MAIN SCROLL VIEW
//           SingleChildScrollView(
//             controller: scrollController,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header Image
//                 Stack(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(tok.radiusLg * 2),
//                         bottomRight: Radius.circular(tok.radiusLg * 2),
//                       ),
//                       child: Image.asset(
//                         AppAssets.addResturentBanner,
//                         width: double.infinity,
//                         height: height * 0.3,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     Positioned(
//                       top: height * 0.086,
//                       left: tok.gap.md,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           AppText(
//                             "Help the Community",
//                             size: AppTextSize.s24,
//                             weight: AppTextWeight.bold,
//                             colorToken: tx.neutral,
//                           ),
//                           AppText(
//                             "Discover LaLah",
//                             size: AppTextSize.s24,
//                             weight: AppTextWeight.bold,
//                             colorToken: tx.neutral,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),

//                 Padding(
//                   padding: EdgeInsets.fromLTRB(
//                     tok.gap.md,
//                     tok.gap.md,
//                     tok.gap.md,
//                     tok.gap.lg * 3, // 👈 bottom safe space
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const FormLabel(label: "Restaurant name"),
//                       AppTextField(
//                         controller: controller.restaurantNameController,
//                         hintText: "Hamza food court",
//                         isOutline: true,
//                       ),
//                       SizedBox(height: tok.gap.md),

//                       const FormLabel(label: "Address"),
//                       AppTextField(
//                         controller: controller.addressController,
//                         hintText: "Full restaurant address",
//                         isOutline: true,
//                       ),
//                       SizedBox(height: tok.gap.md),

//                       const FormLabel(label: "City"),
//                       AppTextField(
//                         controller: controller.cityController,
//                         hintText: "City",
//                         isOutline: true,
//                       ),
//                       SizedBox(height: tok.gap.md),

//                       const FormLabel(label: "Halal Status"),
//                       Obx(
//                         () => Column(
//                           children: controller.halalStatuses.map((status) {
//                             return RadioListTile<String>(
//                               title: AppText(
//                                 status,
//                                 size: AppTextSize.s14,
//                                 weight: AppTextWeight.semibold,
//                                 colorToken: tx.neutral,
//                               ),
//                               value: status,
//                               groupValue: controller.selectedHalalStatus.value,
//                               onChanged: (value) {
//                                 if (value != null)
//                                   controller.setHalalStatus(value);
//                               },
//                               contentPadding: EdgeInsets.zero,
//                               dense: true,
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                       SizedBox(height: tok.gap.md),

//                       const FormLabel(label: "Add restaurant photos"),
//                       SizedBox(height: tok.gap.xs),
//                       Obx(
//                         () => GridView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 3,
//                                 crossAxisSpacing: tok.gap.sm,
//                                 mainAxisSpacing: tok.gap.sm,
//                                 mainAxisExtent: height * 0.118,
//                               ),
//                           itemCount: controller.selectedImages.length + 1,
//                           itemBuilder: (context, index) {
//                             if (index < controller.selectedImages.length) {
//                               return ImagePickerTile(
//                                 image: controller.selectedImages[index],
//                                 onTap: () {},
//                                 onRemove: () => controller.removeImage(index),
//                               );
//                             } else {
//                               return ImagePickerTile(
//                                 isAddButton: true,
//                                 onTap: controller.pickImages,
//                               );
//                             }
//                           },
//                         ),
//                       ),
//                       SizedBox(height: tok.gap.md),

//                       const FormLabel(label: "Additional Note"),
//                       AppTextField(
//                         controller: controller.additionalNoteController,
//                         hintText: "Any helpful detail",
//                         isOutline: true,
//                         maxLines: 4,
//                       ),
//                       SizedBox(height: tok.gap.lg),

//                       Row(
//                         children: [
//                           Expanded(
//                             child: OutlinedButton(
//                               onPressed: controller.clearForm,
//                               child: AppText("Cancel"),
//                             ),
//                           ),
//                           SizedBox(width: tok.gap.md),
//                           Expanded(
//                             child: Obx(
//                               () => ElevatedButton(
//                                 onPressed: controller.isLoading.value
//                                     ? null
//                                     : controller.submitRequest,
//                                 child: controller.isLoading.value
//                                     ? Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           SizedBox(
//                                             height: 18,
//                                             width: 18,
//                                             child: CircularProgressIndicator(
//                                               strokeWidth: 2,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                           SizedBox(width: 10),
//                                           Text("Sending..."),
//                                         ],
//                                       )
//                                     : AppText("Send Request"),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),

//                 const AppFooter(),
//               ],
//             ),
//           ),

//           // 🔥 RIGHT SIDE SCROLL INDICATOR
//           Positioned(
//             right: 4,
//             top: 0,
//             bottom: 0,
//             child: ScrollIndicator(controller: scrollController),
//           ),

//           // 🔥 BOTTOM FADE EFFECT
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: IgnorePointer(
//               child: Container(
//                 height: 40,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.transparent, cs.surface],
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ScrollIndicator extends StatefulWidget {
//   final ScrollController controller;

//   const ScrollIndicator({super.key, required this.controller});

//   @override
//   State<ScrollIndicator> createState() => _ScrollIndicatorState();
// }

// class _ScrollIndicatorState extends State<ScrollIndicator> {
//   double progress = 0;

//   @override
//   void initState() {
//     super.initState();
//     widget.controller.addListener(() {
//       final max = widget.controller.position.maxScrollExtent;
//       final offset = widget.controller.offset;

//       setState(() {
//         progress = max == 0 ? 0 : offset / max;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 4,
//       margin: const EdgeInsets.symmetric(vertical: 40),
//       decoration: BoxDecoration(
//         color: Colors.grey.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Align(
//         alignment: Alignment(0, progress * 2 - 1),
//         child: Container(
//           height: 40,
//           width: 4,
//           decoration: BoxDecoration(
//             color: AppColor.primaryColor,
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       ),
//     );
//   }
// }

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
