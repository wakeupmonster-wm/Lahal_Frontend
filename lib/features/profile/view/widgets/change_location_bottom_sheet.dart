import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lahal_application/features/profile/controller/change_location_controller.dart';
import 'package:lahal_application/features/profile/model/location_model.dart';
import 'package:lahal_application/utils/components/location/use_current_location_tile.dart';
import 'package:lahal_application/utils/components/textfields/app_search_text_field.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/constants/app_svg.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';

class ChangeLocationBottomSheet extends StatefulWidget {
  const ChangeLocationBottomSheet({super.key});

  static Future<LocationModel?> show(BuildContext context) {
    return showModalBottomSheet<LocationModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ChangeLocationBottomSheet(),
    );
  }

  @override
  State<ChangeLocationBottomSheet> createState() =>
      _ChangeLocationBottomSheetState();
}

class _AppAnimatedItem extends StatelessWidget {
  final Widget child;
  final int index;
  final AnimationController controller;

  const _AppAnimatedItem({
    required this.child,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final start = index * 0.05;
    final end = start + 0.4;

    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(
            start.clamp(0.0, 1.0),
            end.clamp(0.0, 1.0),
            curve: Curves.easeIn,
          ),
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: controller,
                curve: Interval(
                  start.clamp(0.0, 1.0),
                  end.clamp(0.0, 1.0),
                  curve: Curves.easeOutQuad,
                ),
              ),
            ),
        child: child,
      ),
    );
  }
}

class _ChangeLocationBottomSheetState extends State<ChangeLocationBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  final controller = Get.put(ChangeLocationController());

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF121212) : cs.surface;
    final textColor = isDark ? Colors.white : tx.neutral;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
        ),
        SizedBox(height: tok.gap.sm),
        Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(tok.radiusLg * 2),
              topRight: Radius.circular(tok.radiusLg * 2),
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: tok.gap.lg,
              vertical: tok.gap.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AppAnimatedItem(
                  index: 0,
                  controller: _animController,
                  child: AppText(
                    "Select a location",
                    size: AppTextSize.s24,
                    weight: AppTextWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: tok.gap.lg),

                _AppAnimatedItem(
                  index: 1,
                  controller: _animController,
                  child: AppSearchField(
                    hintText: "Search for area, street name...",
                    controller: controller.searchController,
                    onChanged: (value) => controller.searchLocations(value),
                  ),
                ),
                SizedBox(height: tok.gap.sm),

                _AppAnimatedItem(
                  index: 2,
                  controller: _animController,
                  child: UseCurrentLocationTile(
                    onTap: () => controller.useCurrentLocation(context),
                    label: AppStrings.useCurrentLocation,
                  ),
                ),
                SizedBox(height: tok.gap.lg),

                Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(
                          color: isDark ? Colors.white : cs.primary,
                        ),
                      ),
                    );
                  }

                  if (controller.searchResults.isEmpty) {
                    return _AppAnimatedItem(
                      index: 3,
                      controller: _animController,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.location_off_outlined,
                              color: tx.subtle,
                              size: 48,
                            ),
                            SizedBox(height: tok.gap.sm),
                            AppText(
                              "No Locations Found",
                              size: AppTextSize.s16,
                              weight: AppTextWeight.bold,
                              color: tx.subtle,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.searchResults.length,
                    separatorBuilder: (context, index) => Divider(
                      color: (isDark ? Colors.white : tx.neutral).withOpacity(
                        0.1,
                      ),
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final location = controller.searchResults[index];
                      return _AppAnimatedItem(
                        index: index + 3,
                        controller: _animController,
                        child: ListTile(
                          onTap: () {
                            controller.selectLocation(location);
                            Navigator.of(context).pop(location);
                          },
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: tok.inset.fieldH,
                            vertical: tok.gap.xxxs,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (isDark ? Colors.white : tx.neutral)
                                  .withOpacity(0.05),
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              AppSvg.locationIcon,
                              colorFilter: ColorFilter.mode(
                                isDark ? Colors.white : tx.neutral,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          title: AppText(
                            location.title,
                            size: AppTextSize.s14,
                            weight: AppTextWeight.bold,
                            color: textColor,
                          ),
                          subtitle: AppText(
                            location.subtitle,
                            size: AppTextSize.s12,
                            color: tx.subtle,
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: tx.subtle,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
