import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/constants/app_svg.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';

class ImagePickerBottomSheet extends StatefulWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCameraTap;
  final VoidCallback onRemoveTap;

  const ImagePickerBottomSheet({
    super.key,
    required this.onGalleryTap,
    required this.onCameraTap,
    required this.onRemoveTap,
  });

  static void show(
    BuildContext context, {
    required VoidCallback onGalleryTap,
    required VoidCallback onCameraTap,
    required VoidCallback onRemoveTap,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ImagePickerBottomSheet(
        onGalleryTap: onGalleryTap,
        onCameraTap: onCameraTap,
        onRemoveTap: onRemoveTap,
      ),
    );
  }

  @override
  State<ImagePickerBottomSheet> createState() => _ImagePickerBottomSheetState();
}

class _ImagePickerBottomSheetState extends State<ImagePickerBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  // Staggered Animations
  late Animation<Offset> _pullBarSlide;
  late Animation<double> _pullBarFade;

  late Animation<Offset> _titleSlide;
  late Animation<double> _titleFade;

  late Animation<Offset> _gallerySlide;
  late Animation<double> _galleryFade;

  late Animation<Offset> _cameraSlide;
  late Animation<double> _cameraFade;

  late Animation<Offset> _removeSlide;
  late Animation<double> _removeFade;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // 1. Pull Bar (0-20%)
    _pullBarSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.0, 0.2, curve: Curves.easeOutQuad),
          ),
        );
    _pullBarFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
      ),
    );

    // 2. Title (10-30%)
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.1, 0.3, curve: Curves.easeOutQuad),
          ),
        );
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.1, 0.3, curve: Curves.easeOut),
      ),
    );

    // 3. Gallery Option (20-40%)
    _gallerySlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.2, 0.4, curve: Curves.easeOutQuad),
          ),
        );
    _galleryFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.2, 0.4, curve: Curves.easeOut),
      ),
    );

    // 4. Camera Option (30-50%)
    _cameraSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.3, 0.5, curve: Curves.easeOutQuad),
          ),
        );
    _cameraFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 0.5, curve: Curves.easeOut),
      ),
    );

    // 5. Remove Option (40-60%)
    _removeSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.4, 0.6, curve: Curves.easeOutQuad),
          ),
        );
    _removeFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.4, 0.6, curve: Curves.easeOut),
      ),
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
    final tok = Theme.of(context).extension<AppTokens>();
    final tx = Theme.of(context).extension<AppTextColors>();
    final cs = Theme.of(context).colorScheme;

    if (tok == null || tx == null) return const SizedBox();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tok.gap.lg,
        vertical: tok.gap.xl,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(tok.radiusLg * 2),
          topRight: Radius.circular(tok.radiusLg * 2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pull Bar
          FadeTransition(
            opacity: _pullBarFade,
            child: SlideTransition(
              position: _pullBarSlide,
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: tok.gap.lg),

          // Title
          FadeTransition(
            opacity: _titleFade,
            child: SlideTransition(
              position: _titleSlide,
              child: AppText(
                AppStrings.changeProfilePhoto,
                size: AppTextSize.s18,
                weight: AppTextWeight.bold,
                color: tx.neutral,
              ),
            ),
          ),
          SizedBox(height: tok.gap.md),

          // Gallery Option
          FadeTransition(
            opacity: _galleryFade,
            child: SlideTransition(
              position: _gallerySlide,
              child: _buildItem(
                svg: AppSvg.galleryIcon,
                label: AppStrings.uploadFromGallery,
                onTap: widget.onGalleryTap,
                tx: tx,
                tok: tok,
              ),
            ),
          ),

          // Camera Option
          FadeTransition(
            opacity: _cameraFade,
            child: SlideTransition(
              position: _cameraSlide,
              child: _buildItem(
                svg: AppSvg.cameraIcon,
                label: AppStrings.takeAPhoto,
                onTap: widget.onCameraTap,
                tx: tx,
                tok: tok,
              ),
            ),
          ),

          // Remove Option
          FadeTransition(
            opacity: _removeFade,
            child: SlideTransition(
              position: _removeSlide,
              child: _buildItem(
                svg: AppSvg.deleteIcon,
                label: AppStrings.removeCurrentPhoto,
                onTap: widget.onRemoveTap,
                tx: tx,
                tok: tok,
                isDanger: true,
              ),
            ),
          ),
          SizedBox(height: tok.gap.md),
        ],
      ),
    );
  }

  Widget _buildItem({
    required String svg,
    required String label,
    required VoidCallback onTap,
    required AppTextColors tx,
    required AppTokens tok,
    bool isDanger = false,
  }) {
    final color = isDanger ? tx.error : tx.primary;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: SvgPicture.asset(
        svg,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        width: tok.iconLg,
        height: tok.iconLg,
      ),
      title: AppText(
        label,
        size: AppTextSize.s14,
        weight: AppTextWeight.bold,
        color: tx.primary,
      ),
      onTap: onTap,
    );
  }
}
