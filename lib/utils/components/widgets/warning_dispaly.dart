import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lahal_application/utils/constants/app_assets.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/app_button.dart';

class WarningDisplay extends StatelessWidget {
  final String warningMessage;
  final String subWarningMessage;
  final double? boxHeight;
  final String iconPath;
  final VoidCallback? onRetry;

  const WarningDisplay({
    super.key,
    this.warningMessage = 'No data available at the moment.',
    this.subWarningMessage = 'Please check back later or try again..',
    this.boxHeight,
    this.iconPath = "",
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SizedBox(
      width: width,
      height: boxHeight ?? height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(iconPath, width: width * 0.15),
          SizedBox(height: height * 0.015),
          AppText(
            warningMessage,
            weight: AppTextWeight.bold,
            size: AppTextSize.s16,
            color: tx.primary,
          ),
          SizedBox(height: height * 0.005),
          AppText(
            subWarningMessage,
            weight: AppTextWeight.medium,
            size: AppTextSize.s12,
            color: tx.subtle,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            SizedBox(height: height * 0.04),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: tok.gap.xxl),
              child: AppButton(
                label: "Retry",
                onPressed: onRetry,
                variant: AppButtonVariant.primary,
                minWidth: width * 0.3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
