import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lahal_application/features/profile/controller/location_controller.dart';
import 'package:lahal_application/features/profile/model/location_model.dart';
import 'package:lahal_application/utils/components/appbar/internal_app_bar.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/constants/app_colors.dart';
import 'package:lahal_application/utils/components/location/location_search_bar.dart';
import 'package:lahal_application/utils/components/location/use_current_location_tile.dart';

class ChangeLocationScreen extends StatelessWidget {
  const ChangeLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocationController());
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
              // Search Bar
              LocationSearchBar(
                controller: controller.searchController,
                onChanged: (value) => controller.searchLocations(value),
                hintText: AppStrings.searchLocationHint,
              ),
              SizedBox(height: tok.gap.md),

              // Use Current Location
              UseCurrentLocationTile(
                onTap: () => controller.useCurrentLocation(),
                label: AppStrings.useCurrentLocation,
              ),
              SizedBox(height: tok.gap.lg),

              // Results Container
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.searchResults.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Container(
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: cs.outlineVariant.withOpacity(0.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.searchResults.length,
                    separatorBuilder: (context, index) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: tok.gap.md),
                      child: Divider(
                        color: cs.outlineVariant.withOpacity(0.3),
                        height: 1,
                      ),
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
    );
  }

  // Helper method for ListView.separated (itemBuilder replacement logic)
  Widget _buildLocationItem(
    BuildContext context,
    LocationModel location,
    AppTokens tok,
    AppTextColors tx,
    ColorScheme cs,
    LocationController controller,
  ) {
    return ListTile(
      onTap: () => controller.selectLocation(location),
      contentPadding: EdgeInsets.symmetric(
        horizontal: tok.gap.md,
        vertical: tok.gap.xxs,
      ),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: cs.surface, shape: BoxShape.circle),
        child: Icon(Icons.location_on_outlined, color: tx.neutral, size: 22),
      ),
      title: AppText(
        location.title,
        size: AppTextSize.s16,
        weight: AppTextWeight.semibold,
        color: tx.subtle,
      ),
      subtitle: AppText(
        location.subtitle,
        size: AppTextSize.s12,
        color: tx.subtle,
      ),
      trailing: Icon(Icons.chevron_right, color: tx.subtle, size: 20),
    );
  }
}
