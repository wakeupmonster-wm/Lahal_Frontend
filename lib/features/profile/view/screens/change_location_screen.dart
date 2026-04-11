import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lahal_application/features/profile/controller/change_location_controller.dart';
import 'package:lahal_application/features/profile/model/location_model.dart';
import 'package:lahal_application/utils/components/appbar/internal_app_bar.dart';
import 'package:lahal_application/utils/components/textfields/app_search_text_field.dart';
import 'package:lahal_application/utils/components/widgets/empty_state_widget.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/constants/app_svg.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/components/location/use_current_location_tile.dart';
import 'package:lahal_application/utils/theme/app_button.dart';

class ChangeLocationScreen extends StatelessWidget {
  const ChangeLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangeLocationController());
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: InternalAppBar(
        title: AppStrings.changeLocationTitle,
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: tok.gap.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: tok.gap.md),
              Obx(() => AppSearchField(
                hintText: AppStrings.searchLocationHint,
                controller: controller.searchController,
                onChanged: (value) => controller.onSearchTextChanged(value),
                suffixIcon: controller.showClearButton.value
                    ? GestureDetector(
                        onTap: controller.clearSearch,
                        child: Icon(
                          Icons.close,
                          color: tx.subtle,
                          size: tok.iconSm, // Using iconSm as it's typically ~20-24px
                        ),
                      )
                    : null,
              )),

              // Search Bar
              SizedBox(height: tok.gap.md),

              // Use Current Location
              UseCurrentLocationTile(
                onTap: () => controller.useCurrentLocation(context),
                label: AppStrings.useCurrentLocation,
              ),
              SizedBox(height: tok.gap.lg),

              // Results Container
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.searchResults.isEmpty && controller.searchController.text.isNotEmpty) {
                  return const EmptyStateWidget(
                    title: "No Locations Found",
                    description: "We couldn't find any locations matching your search.",
                  );
                }
                if (controller.searchResults.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Container(
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(12),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.searchResults.length,
                    separatorBuilder: (context, index) => Divider(
                      color: cs.outlineVariant.withOpacity(0.3),
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final location = controller.searchResults[index];
                      return _buildLocationItem(
                        context,
                        location,
                        tok,
                        tx,
                        cs,
                        controller,
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(tok.gap.lg),
          child: Obx(
            () => AppButton(
              label: "Save Location",
              onPressed: controller.isSaveEnabled.value
                  ? () => controller.saveLocation()
                  : null,
              loading: controller.isSaving.value,
              disabled: !controller.isSaveEnabled.value,
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for ListView.separated (itemBuilder replacement logic)
  Widget _buildLocationItem(
    BuildContext context,
    LocationModel location,
    AppTokens tok,
    AppTextColors tx,
    ColorScheme cs,
    ChangeLocationController controller,
  ) {
    return ListTile(
      onTap: () => controller.selectLocation(location),
      contentPadding: EdgeInsets.symmetric(
        horizontal: tok.inset.fieldH,
        vertical: tok.gap.xxxs,
      ),
      leading: Container(
        decoration: BoxDecoration(color: cs.surface, shape: BoxShape.circle),
        child: SvgPicture.asset(AppSvg.locationIcon),
      ),
      title: AppText(
        location.title,
        size: AppTextSize.s14,
        weight: AppTextWeight.bold,
        color: tx.subtle,
      ),
      subtitle: AppText(
        location.subtitle,
        size: AppTextSize.s14,
        color: tx.subtle,
      ),
      trailing: Icon(Icons.chevron_right, color: tx.subtle, size: 20),
    );
  }
}
