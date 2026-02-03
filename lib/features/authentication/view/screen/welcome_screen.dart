import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lahal_application/utils/constants/app_assets.dart';
import 'package:lahal_application/utils/routes/app_pages.dart';
import 'package:lahal_application/utils/theme/app_button.dart';
import 'package:lahal_application/utils/theme/app_tokens.dart';
import 'package:lahal_application/utils/theme/text/app_text.dart';
import 'package:lahal_application/utils/theme/text/app_text_color.dart';
import 'package:lahal_application/utils/theme/text/app_typography.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tx = Theme.of(context).extension<AppTextColors>()!;
    final cs = Theme.of(context).colorScheme;
    final tok = Theme.of(context).extension<AppTokens>()!;
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    return Scaffold(
      body: Stack(
        children: [
          const Image(
            image: AssetImage(AppAssets.onboarding),
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Positioned.fill(
            top: height * 0.1, // vertical offset
            child: Align(
              alignment: Alignment.topCenter,
              child: SvgPicture.asset(AppAssets.appLogo_1, width: width * 0.3),
            ),
          ),

          //SizedBox.expand(),
          Positioned(
            bottom: height * 0.06,
            child: SizedBox(
              width: width,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                child: Column(
                  children: [
                    AppText(
                      'Welcome to Match at First Swipe',
                      size: AppTextSize.s18,
                      weight: AppTextWeight.extraBold,
                      color: tx.subtle,
                    ),
                    SizedBox(height: tok.gap.sm),
                    AppText(
                      'By Signing Up you are agreeing with Match At First Swipe Terms of Service and our Privacy Policy.',
                      size: AppTextSize.s12,
                      weight: AppTextWeight.medium,
                      color: tx.subtle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: tok.gap.xl),
                    // Primary XL
                    AppButton(
                      label: 'Create Account',
                      bgColorOverride: cs.secondary,
                      variant: AppButtonVariant.primary,
                      onPressed: () {},
                      // loading: true,
                    ),
                    SizedBox(height: tok.gap.sm),
                    // With icons
                    AppButton(
                      label: 'Sign In',
                      variant: AppButtonVariant.ghost,
                      fgColorOverride: tx.subtle,
                      onPressed: () {
                        context.go(AppRoutes.bottomNavigationBar);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
