import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/features/authentication/controller/otp_controller.dart';
import 'package:lahal_application/utils/components/appbar/internal_app_bar.dart';
import 'package:lahal_application/utils/components/textfields/otp_text_field.dart';
import 'package:lahal_application/utils/constants/app_colors.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/constants/enum.dart';
import 'package:lahal_application/utils/theme/app_button.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class OtpVerificationScreen extends StatelessWidget {
  final AuthEntryMode mode;
  final String? data;
  const OtpVerificationScreen({super.key, required this.mode, this.data});

  @override
  Widget build(BuildContext context) {
    // Register controller with length 6
    final OtpController ctrl = Get.put(OtpController(length: 6));

    final tx = Theme.of(context).extension<AppTextColors>()!;
    final tok = Theme.of(context).extension<AppTokens>()!;
    final cs = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);

    // Calculate box width dynamically to fit 6 items
    // Screen width - padding.
    final availableWidth =
        mediaQuery.size.width - (tok.gap.lg * 2); // padding horizontal
    // 6 boxes + 5 gaps. Gap likely smaller.
    // Let's assume OtpField uses spaceBetween.
    // Box width around 45-50.
    final double boxW = (availableWidth / 6) - 10;

    return Scaffold(
      appBar: const InternalAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: tok.gap.xs,
          horizontal: tok.gap.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            AppText(
              AppStrings.otpVerification,
              size: AppTextSize.s18,
              weight: AppTextWeight.bold,
              color: tx.neutral,
            ),
            SizedBox(height: tok.gap.xs),
            // Subtitle
            AppText(
              "We have sent a verification code to - ${data ?? ''}",
              size: AppTextSize.s14,
              weight: AppTextWeight.regular,
              color: tx.subtle,
              overflow: TextOverflow.visible,
            ),
            SizedBox(height: tok.gap.xxl),

            // OTP Field
            Center(
              child: OtpField(
                length: 6,
                boxWidth: boxW,
                onCompleted: (code) {
                  ctrl.setOtp(code);
                },
              ),
            ),

            SizedBox(height: tok.gap.xl),

            // Resend Logic
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    AppStrings.didntReceiveCode,
                    size: AppTextSize.s14, // Matches image style
                    weight: AppTextWeight.bold,
                    color: tx.neutral,
                  ),
                  GestureDetector(
                    onTap: ctrl.remainingSeconds.value > 0
                        ? null
                        : () => ctrl.resendOtp(),
                    child: AppText(
                      ctrl.remainingSeconds.value > 0
                          ? " Resend in ${ctrl.remainingSeconds.value}s"
                          : AppStrings.resendSms,
                      size: AppTextSize.s14,
                      weight: AppTextWeight.bold,
                      color: ctrl.remainingSeconds.value > 0
                          ? tx.subtle
                          : AppColor.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: tok.gap.md),

            // Check text messages hint
            Center(
              child: AppText(
                AppStrings.checkTextMessages,
                size: AppTextSize.s14,
                weight: AppTextWeight.medium,
                color: Colors.blue, // Or explicit blue color if in tokens
              ),
            ),

            const Spacer(),

            // Go Back to Login Button
            Padding(
              padding: EdgeInsets.only(
                bottom: tok.gap.lg + mediaQuery.padding.bottom,
              ),
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: AppStrings.goBackToLogin,
                  variant: AppButtonVariant.outline,
                  borderColorOverride: cs.primary, // Green border
                  onPressed: () {
                    context.pop(); // Go back
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
