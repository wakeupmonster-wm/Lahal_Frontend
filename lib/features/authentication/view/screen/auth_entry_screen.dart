import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lahal_application/utils/components/appbar/internal_app_bar.dart';
import 'package:lahal_application/utils/components/textfields/app_text_field.dart';
import 'package:lahal_application/utils/constants/enum.dart';
import 'package:lahal_application/utils/constants/app_strings.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';
import 'package:lahal_application/utils/theme/app_button.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';
import 'package:lahal_application/utils/validators/validators.dart';

class AuthEntryScreen extends StatelessWidget {
  final AuthEntryMode mode;
  const AuthEntryScreen({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final tok = Theme.of(context).extension<AppTokens>()!;
    final cs = Theme.of(context).colorScheme;
    final phoneController = TextEditingController(text: '1234567890');
    final emailController = TextEditingController(text: 'test@gmail.com');
    final _formKey = GlobalKey<FormState>();
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
              mode == AuthEntryMode.phone
                  ? AppStrings.letsGetStarted
                  : AppStrings.verifyEmail,
              size: AppTextSize.s18,
              weight: AppTextWeight.bold,
              color: tx.neutral,
            ),
            SizedBox(height: tok.gap.xs),
            // Subtitle
            AppText(
              mode == AuthEntryMode.phone
                  ? AppStrings.letsGetStartedDesc
                  : AppStrings.verifyEmailDesc,
              size: AppTextSize.s16,
              weight: AppTextWeight.regular,
              color: tx.subtle,
            ),
            SizedBox(height: tok.gap.lg),

            // TextField
            if (mode == AuthEntryMode.phone) ...[
              Form(
                key: _formKey,
                child: AppTextField(
                  label: AppStrings.phoneNumberLabel,
                  hintText: 'Enter phone number',
                  prefix: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: tok.gap.xxs),
                        child: AppText(
                          '+61',
                          size: AppTextSize.s16,
                          weight: AppTextWeight.semibold,
                          color: tx.muted,
                        ),
                      ),
                      SizedBox(width: tok.gap.xxs),
                      Container(
                        width: 1,
                        height: tok.gap.lg,
                        color: cs.outlineVariant,
                      ),
                    ],
                  ),
                  maxLength: 10,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  validator: Validator.validateContactNo,
                  onChanged: (s) {},
                ),
              ),
            ],
            if (mode == AuthEntryMode.email) ...[
              Form(
                key: _formKey,
                child: AppTextField(
                  label: AppStrings.emailLabel,
                  hintText: 'Enter email',
                  prefix: Icon(Iconsax.direct_normal_bold, size: tok.iconLg),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validator.validateEmail,
                  onChanged: (s) {},
                ),
              ),
            ],
            // Take full spacing
            const Spacer(),
            // Privacy Text
            Align(
              alignment: Alignment.bottomCenter,
              child: AppText(
                AppStrings.privacySafe,
                size: AppTextSize.s12,
                weight: AppTextWeight.regular,
                color: tx.subtle,
              ),
            ),
            SizedBox(height: tok.gap.lg),
            // Continue Button
            AppButton(
              label: AppStrings.continueText,
              bgColorOverride: cs.secondary,
              variant: AppButtonVariant.primary,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.push(
                    AppRoutes.otpVerify,
                    extra: {
                      'mode': mode,
                      'data': mode == AuthEntryMode.phone
                          ? phoneController.text
                          : emailController.text,
                    },
                  );
                }
              },
            ),
            SizedBox(height: tok.gap.xl),
          ],
        ),
      ),
    );
  }
}

// -- App Bars
// 1. Home App Bar
// 2. Main Screens App bar ( Profile, FWB, Chat, Matches)
// 3. Internal Screens App Bar (Left Back Icon, Title In center optional or linear Progress Bar if title no progess bar is progress bar no title and also both are optional, Can have custom suffix icon with logic )
// 4. Chat Screen App Bar (Left Back Icon, Profile Image, Title, suffix icon with logic )

// Textfields
// 1. Phone Number TextField ( Hind color - textmuted, Text color - textnetural, bg color - surfaceContainerHighest)
// 2. Email TextField with prefix icon
// 3. OTP TextField
// 4. Search TextField
// 5. Create a custom textfield widget for all this textfield combine (phone, email, search, Hind color - textmuted, Text color - textnetural, bg color - surfaceContainerHighest),
//   this are all the params -- it can has custom prefix icons, String? Function(String?)? validator;final Function(String)? onChange; final Function(String)? onSubmit; final TextEditingController? controller; final String hintText;
//   and if textfield is active we will have border in primary color and text will be same and if it is disable or untapped we will have border in outline color and text will be same
// and we can have a textfield heading which is optionl just like this
/// AppText(
///   AppStrings.phoneNumberLabel,
///   size: AppTextSize.s18,
///   weight: AppTextWeight.bold,
///   color: tx.neutral,
/// ),
