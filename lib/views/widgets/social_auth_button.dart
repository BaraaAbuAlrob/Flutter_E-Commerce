import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';

enum SocialProvider { google, facebook }

class SocialAuthButton extends StatelessWidget {
  final SocialProvider provider;
  final VoidCallback onTap;
  final bool isLoading;
  final bool isSignUp;
  final String? customTitle;

  const SocialAuthButton({
    super.key,
    required this.provider,
    required this.onTap,
    this.isLoading = false,
    this.isSignUp = false,
    this.customTitle,
  });

  Widget _socialIcon(SocialProvider provider) {
    if (provider == SocialProvider.google) {
      return Image.asset(
        'assets/images/signin_signup_images/google.png',
        width: 22,
        height: 22,
        errorBuilder: (context, error, stackTrace) => const FaIcon(
          FontAwesomeIcons.google,
          color: Color(0xFFEA4335),
          size: 22,
        ),
      );
    } else {
      return const FaIcon(
        FontAwesomeIcons.facebook,
        color: Color(0xFF1877F2),
        size: 22,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGoogle = provider == SocialProvider.google;
    final defaultTitle = isSignUp
        ? (isGoogle ? 'Sign Up with Google' : 'Sign Up with Facebook')
        : (isGoogle ? 'Sign In with Google' : 'Sign In with Facebook');
    final title = customTitle ?? defaultTitle;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: isLoading ? null : onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          side: const BorderSide(color: Color(0xFFE5E7EB), width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.authPrimary,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialIcon(provider),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.authTextDark,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
