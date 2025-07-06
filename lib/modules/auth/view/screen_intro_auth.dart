import 'package:flutter/material.dart';
import 'package:cennec/modules/core/common/widgets/button.dart';
import 'package:cennec/modules/core/utils/app_colors.dart';
import 'package:cennec/modules/core/utils/app_config.dart';
import 'package:cennec/modules/core/utils/app_dimens.dart';
import 'package:cennec/modules/core/utils/app_font.dart';
import 'package:cennec/modules/core/utils/common_import.dart';

class ScreenWelcome extends StatelessWidget {
  const ScreenWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorDarkBlue,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Logo
                Image.asset(
                  APPImages.icCennecBottom,
                  height: 44,
                  width: 44,
                ),
                const SizedBox(height: 32),

                // Heading
                Text(
                  getTranslate(APPStrings.textExploreConnections),
                  textAlign: TextAlign.center,
                  style: getTextStyleFromFont(
                    AppFont.poppins,
                    Dimens.margin28,
                    Colors.white,
                    FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),

                // Subtext
                Text(
                  getTranslate(APPStrings.textWelcomeSubText),
                  textAlign: TextAlign.center,
                  style: getTextStyleFromFont(
                    AppFont.poppins,
                    Dimens.margin18,
                    Colors.white70,
                    FontWeight.w500,
                  ),
                ),
                const Spacer(),

                // Login Button (Filled)
                CommonButton(
                  text: getTranslate(APPStrings.textSignIn),
                  backgroundColor: Colors.white,
                  textColor: AppColors.colorDarkBlue,
                  borderRadius: BorderRadius.circular(12),
                  height: Dimens.margin60,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.routesLogin);
                  },
                ),
                const SizedBox(height: 16),

                // Sign Up Button (Outlined)
                CommonButton(
                  text: getTranslate(APPStrings.textSignUp),
                  isOutlined: true,
                  borderColor: Colors.white,
                  textColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  height: Dimens.margin60,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.routesSignUp);
                  },
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
