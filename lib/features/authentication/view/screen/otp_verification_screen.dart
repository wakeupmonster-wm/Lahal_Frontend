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
    final OtpController ctrl = Get.put(OtpController(length: 6));

    final tx = Theme.of(context).extension<AppTextColors>()!;
    final tok = Theme.of(context).extension<AppTokens>()!;
    final cs = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);

    final availableWidth =
        mediaQuery.size.width - (tok.gap.lg * 2); // padding horizontal
    final double boxW = (availableWidth / 6) - 10;

    return Scaffold(
      appBar: InternalAppBar(
        title: AppStrings.otpVerification,
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: tok.gap.xs,
              horizontal: tok.gap.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: tok.gap.xs),
                AppText(
                  "${AppStrings.weHaveSentVerificationCodeTo} - ${data ?? ''}",
                  size: AppTextSize.s14,
                  weight: AppTextWeight.regular,
                  color: tx.subtle,
                  overflow: TextOverflow.visible,
                ),
                SizedBox(height: tok.gap.xxl),

                Center(
                  child: OtpField(
                    length: 6,
                    boxWidth: boxW,
                    onCompleted: (code) {
                      ctrl.setOtp(code, context);
                    },
                  ),
                ),

                SizedBox(height: tok.gap.xl),

                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        AppStrings.didntReceiveCode,
                        size: AppTextSize.s14,
                        weight: AppTextWeight.bold,
                        color: tx.neutral,
                      ),
                      GestureDetector(
                        onTap:
                            ctrl.remainingSeconds.value > 0 ||
                                ctrl.isLoading.value
                            ? null
                            : () => ctrl.resendOtp(),
                        child: AppText(
                          ctrl.remainingSeconds.value > 0
                              ? "${AppStrings.resendSms} ${ctrl.remainingSeconds.value}${AppStrings.secondsSuffix}"
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

                Center(
                  child: AppText(
                    AppStrings.checkTextMessages,
                    size: AppTextSize.s14,
                    weight: AppTextWeight.medium,
                    color: tx.subtle,
                  ),
                ),

                const Spacer(),

                Padding(
                  padding: EdgeInsets.only(
                    bottom: tok.gap.lg + mediaQuery.padding.bottom,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      radiusOverride: tok.gap.xs,
                      label: AppStrings.goBackToLogin,
                      variant: AppButtonVariant.outline,
                      borderColorOverride: cs.primary,
                      fgColorOverride: cs.primary,
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Loading Overlay
          Obx(() {
            if (ctrl.isLoading.value) {
              return Container(
                color: tx.neutral.withOpacity(0.1),
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
