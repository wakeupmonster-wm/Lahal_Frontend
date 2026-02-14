import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lahal_application/utils/constants/app_svg.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class ImagePickerTile extends StatelessWidget {
  final File? image;
  final VoidCallback onTap;
  final VoidCallback? onRemove;
  final bool isAddButton;

  const ImagePickerTile({
    super.key,
    this.image,
    required this.onTap,
    this.onRemove,
    this.isAddButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final cs = Theme.of(context).colorScheme;

    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.only(right: tok.gap.sm),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(tok.radiusMd),
              border: Border.all(color: cs.outline),
            ),
            child: isAddButton
                ? Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: tok.gap.xxl,
                      vertical: tok.gap.xxl,
                    ),
                    child: SvgPicture.asset(
                      AppSvg.galleryAddIcon,
                      colorFilter: ColorFilter.mode(
                        cs.onSurfaceVariant.withOpacity(0.5),
                        BlendMode.srcIn,
                      ),
                      width: tok.iconSm,
                      height: tok.iconSm,
                    ),
                  )
                // Icon(
                //     Icons.add_photo_alternate_outlined,
                //     color: cs.onSurfaceVariant.withOpacity(0.5),
                //     size: tok.iconLg,
                //   )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(tok.radiusMd),
                    child: Image.file(image!, fit: BoxFit.cover),
                  ),
          ),
        ),
        if (!isAddButton && onRemove != null)
          Positioned(
            top: 4,
            right: tok.gap.sm + 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: cs.error,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 14),
              ),
            ),
          ),
      ],
    );
  }
}

class FormLabel extends StatelessWidget {
  final String label;
  const FormLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;

    return Padding(
      padding: EdgeInsets.only(bottom: tok.gap.xs),
      child: AppText(
        label,
        size: AppTextSize.s14,
        weight: AppTextWeight.semibold,
        colorToken: tx.neutral,
      ),
    );
  }
}
