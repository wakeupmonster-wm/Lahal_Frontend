import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lahal_application/features/authentication/controller/sign_in_controller.dart';
import 'package:lahal_application/features/authentication/view/widget/social_login_widget.dart';
import 'package:lahal_application/utils/components/textfields/app_text_field.dart';
import 'package:lahal_application/utils/constants/app_assets.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final tok = Theme.of(context).extension<AppTokens>()!;
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: height * 0.45,
                child: Image.asset(AppAssets.biryaniImage, fit: BoxFit.cover),
              ),
              Positioned(
                top: height * 0.35,
                left: 0,
                right: 0,
                height: height * 0.25,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,

                      colors: [
                        cs.surface.withOpacity(0.0),
                        cs.surface.withOpacity(0.6),
                        cs.surface,
                        cs.surface,
                        cs.surface,
                        cs.surface,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    left: tok.gap.md,
                    right: tok.gap.md,
                    bottom: tok.gap.xxs + mediaQuery.padding.bottom,
                  ),
                  color: cs.surface,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        AppStrings.findFoodThatAligns,
                        textAlign: TextAlign.center,
                        size: AppTextSize.s24,
                        weight: AppTextWeight.bold,
                        color: cs.onSurface,
                      ),

                      SizedBox(height: tok.gap.md),

                      Row(
                        children: [
                          Expanded(
                            child: Divider(color: cs.outline, thickness: 0.8),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: tok.gap.xs,
                            ),
                            child: AppText(
                              AppStrings.loginOrSignup,
                              size: AppTextSize.s14,
                              weight: AppTextWeight.medium,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          Expanded(
                            child: Divider(color: cs.outline, thickness: 0.8),
                          ),
                        ],
                      ),

                      SizedBox(height: tok.gap.md),

                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: controller.formKey,
                              child: AppTextField(
                                hintText: AppStrings.enterPhoneNumber,
                                prefix: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: tok.gap.xxs,
                                      ),
                                      child: AppText(
                                        'AU (+61)',
                                        size: AppTextSize.s14,
                                        weight: AppTextWeight.semibold,
                                        color: tx.neutral,
                                      ),
                                    ),
                                    SizedBox(width: tok.gap.xxs),
                                    Container(
                                      width: 1,
                                      height: tok.gap.lg,
                                      color: cs.outline,
                                    ),
                                  ],
                                ),
                                maxLength: 10,
                                controller: controller.phoneNumberController,
                                keyboardType: TextInputType.phone,
                                // validator: Validator.validateContactNo,
                                onChanged: (s) {},
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: tok.gap.xs),

                      Row(
                        children: [
                          Obx(
                            () => SizedBox(
                              width: tok.iconLg,
                              height: tok.iconLg,
                              child: Checkbox(
                                value: controller.rememberMe.value,
                                onChanged: controller.toggleRememberMe,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                side: BorderSide(color: cs.outlineVariant),
                              ),
                            ),
                          ),
                          SizedBox(width: tok.gap.xs),
                          AppText(
                            AppStrings.rememberMyLogin,
                            size: AppTextSize.s12,
                            weight: AppTextWeight.medium,
                            color: tx.subtle,
                          ),
                        ],
                      ),

                      SizedBox(height: tok.gap.md),

                      SizedBox(
                        width: double.infinity,
                        height: tok.appBarHeight,
                        child: ElevatedButton(
                          onPressed: () => controller.onGetStarted(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cs.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(tok.radiusMd),
                            ),
                          ),
                          child: AppText(
                            color: cs.onPrimary,
                            AppStrings.getStarted,
                            size: AppTextSize.s16,
                            weight: AppTextWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: tok.gap.md),

                      const SocialLoginRow(),

                      SizedBox(height: tok.gap.md),

                      Column(
                        children: [
                          AppText(
                            AppStrings.byContinuingYouAgreeToOur,
                            size: AppTextSize.s10,
                            weight: AppTextWeight.medium,
                            color: tx.subtle,
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppText(
                                  "${AppStrings.termsOfService}  ",
                                  size: AppTextSize.s10,
                                  weight: AppTextWeight.medium,
                                  color: tx.subtle,
                                ),
                                AppText(
                                  "${AppStrings.privacyPolicy}  ",
                                  size: AppTextSize.s10,
                                  weight: AppTextWeight.medium,
                                  color: tx.subtle,
                                ),
                                AppText(
                                  AppStrings.contentPolicy,
                                  size: AppTextSize.s10,
                                  weight: AppTextWeight.medium,
                                  color: tx.subtle,
                                  textDecoration: TextDecoration.underline,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
