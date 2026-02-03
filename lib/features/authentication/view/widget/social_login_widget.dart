import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lahal_application/utils/constants/app_assets.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class SocialLoginRow extends StatelessWidget {
  final VoidCallback? onGoogle;
  final VoidCallback? onFacebook;
  final VoidCallback? onApple;

  const SocialLoginRow({
    super.key,
    this.onGoogle,
    this.onFacebook,
    this.onApple,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: tok.gap.lg),
      child: Column(
        children: [
          // --------- Divider + OR ----------
          Row(
            children: [
              Expanded(
                child: Divider(color: cs.outlineVariant, thickness: 0.8),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: tok.gap.md),
                child: AppText(
                  "Or",
                  size: AppTextSize.s14,
                  weight: AppTextWeight.bold,
                  color: tx.subtle,
                ),
              ),
              Expanded(
                child: Divider(color: cs.outlineVariant, thickness: 0.8),
              ),
            ],
          ),
          SizedBox(height: tok.gap.md),
          // --------- Social Buttons Row ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppAssets.socialGoogle, width: tok.iconLg + 13),
              SizedBox(width: tok.gap.lg),
              SvgPicture.asset(AppAssets.socialApple, width: tok.iconLg + 13),
            ],
          ),
        ],
      ),
    );
  }
}
