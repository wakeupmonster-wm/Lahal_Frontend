import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:lahal_application/features/authentication/controller/otp_controller.dart';
import 'package:lahal_application/features/authentication/services/auth_state_service.dart';
import 'package:lahal_application/utils/components/appbar/internal_app_bar.dart';
import 'package:lahal_application/utils/components/widgets/full_screen_stack_loading.dart';
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
    // Always delete any stale instance so we get a fresh controller with the
    // phone number baked in (avoids empty-phone bug on second visit).
    if (Get.isRegistered<OtpController>()) {
      Get.delete<OtpController>(force: true);
    }

    final phone = data ?? '';
    final OtpController ctrl = Get.put(OtpController(length: 6, phone: phone));

    final tx = Theme.of(context).extension<AppTextColors>()!;
    final tok = Theme.of(context).extension<AppTokens>()!;
    final cs = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    // --- Pinput theme ---
    final defaultPinTheme = PinTheme(
      width: width * 0.13,
      height: width * 0.13,
      textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: cs.onSurface,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(tok.radiusMd),
        border: Border.all(color: cs.outlineVariant),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: cs.primary, width: 1.6),
      ),
    );

    final filledPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: cs.outline),
      ),
    );

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
                  "${AppStrings.weHaveSentVerificationCodeTo} - ${phone.isNotEmpty ? phone : '—'}",
                  size: AppTextSize.s14,
                  weight: AppTextWeight.regular,
                  color: tx.subtle,
                  overflow: TextOverflow.visible,
                ),
                SizedBox(height: tok.gap.xxl),

                Center(
                  child: Pinput(
                    length: 6,
                    controller: ctrl.pinputController,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: filledPinTheme,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    // Paste support is built-in to Pinput
                    onChanged: (value) {
                      ctrl.otp.value = value;
                    },
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
                            : () => ctrl.resendOtp(context),
                        child: AppText(
                          ctrl.remainingSeconds.value > 0
                              ? "${AppStrings.resendSms} ${ctrl.remainingSeconds.value}${AppStrings.secondsSuffix}"
                              : AppStrings.resendSms,
                          size: AppTextSize.s12,
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

                // Center(
                //   child: AppText(
                //     AppStrings.checkTextMessages,
                //     size: AppTextSize.s14,
                //     weight: AppTextWeight.medium,
                //     color: tx.subtle,
                //   ),
                // ),
                const Spacer(),

                Padding(
                  padding: EdgeInsets.only(
                    bottom: tok.gap.lg + mediaQuery.padding.bottom,
                  ),
                  child: SizedBox(
                    height: height * 0.0515,
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
            final isBusy = ctrl.isLoading.value || 
                           Get.find<AuthStateService>().isAuthenticating.value;
            return StackLaoding(isLoading: isBusy);
          }),
        ],
      ),
    );
  }
}
