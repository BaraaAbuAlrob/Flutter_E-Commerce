import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models/login_cubit/login_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_auth_text_field.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_confirm_dialog.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_snack_bar.dart';
import 'package:flutter_ecommerce_app/views/widgets/forgot_password_bottom_sheet.dart';
import 'package:flutter_ecommerce_app/views/widgets/social_auth_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isValidEmail = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkValidation);
  }

  void _checkValidation() {
    final cubit = context.read<LoginCubit>();
    final value = _emailController.text.trim();
    final isValid = cubit.isValidEmail(value);
    if (isValid != _isValidEmail) {
      setState(() {
        _isValidEmail = isValid;
      });
    }
  }

  @override
  void dispose() {
    _emailController.removeListener(_checkValidation);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleBackPress() async {
    final shouldExit = await CustomConfirmDialog.show(
      context: context,
      title: 'Exit Application',
      message: 'Are you sure you want to exit the application?',
      confirmText: 'Exit',
      cancelText: 'Cancel',
      icon: Icons.exit_to_app_rounded,
      iconColor: AppColors.red,
      confirmButtonColor: AppColors.red,
    );

    if (shouldExit == true) {
      SystemNavigator.pop();
    }
  }

  void _onSignInPressed(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final cubit = context.read<LoginCubit>();

    if (email.isEmpty) {
      CustomSnackBar.show(
        context,
        message: 'Please enter your email',
        type: SnackBarType.error,
      );
      return;
    }

    if (!cubit.isValidEmail(email)) {
      CustomSnackBar.show(
        context,
        message: 'Please enter a valid email address (e.g. name@mail.com)',
        type: SnackBarType.error,
      );
      return;
    }

    if (password.isEmpty) {
      CustomSnackBar.show(
        context,
        message: 'Please enter your password',
        type: SnackBarType.error,
      );
      return;
    }

    if (password.length < 6) {
      CustomSnackBar.show(
        context,
        message: 'Password must be at least 6 characters',
        type: SnackBarType.error,
      );
      return;
    }

    cubit.signIn(
      email: email,
      password: password,
    );
  }

  void _onForgotPasswordPressed(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    showForgotPasswordBottomSheet(
      context: context,
      loginCubit: cubit,
      initialValue: _emailController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackPress();
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginFailure) {
                CustomSnackBar.show(
                  context,
                  message: state.errorMessage,
                  type: SnackBarType.error,
                );
              } else if (state is LoginSuccess) {
                CustomSnackBar.show(
                  context,
                  message: state.message,
                  type: SnackBarType.success,
                );
                Navigator.of(context).pushReplacementNamed(AppRoutes.homePage);
              } else if (state is SocialLoginSuccess) {
                CustomSnackBar.show(
                  context,
                  message: state.message,
                  type: SnackBarType.success,
                );
                Navigator.of(context).pushReplacementNamed(AppRoutes.homePage);
              } else if (state is SocialLoginFailure) {
                CustomSnackBar.show(
                  context,
                  message: state.errorMessage,
                  type: SnackBarType.error,
                );
              }
            },
            builder: (context, state) {
              final isLoginLoading = state is LoginLoading;
              final isGoogleLoading =
                  state is SocialLoginLoading && state.provider == 'Google';
              final isFacebookLoading =
                  state is SocialLoginLoading && state.provider == 'Facebook';

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),

                    // Header: Login Account
                    const Text(
                      'Login Account',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.authTextDark,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Subtitle
                    const Text(
                      'Please login with registered account',
                      style: TextStyle(
                        fontSize: 14.5,
                        color: AppColors.authTextSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Field 1: Email with Live Validation Indicator
                    CustomAuthTextField(
                      label: 'Email',
                      hintText: 'Enter your email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(
                        Icons.mail_outline_rounded,
                        color: AppColors.authPrimary,
                        size: 22,
                      ),
                      suffixIcon: _isValidEmail
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColors.authSuccess,
                              size: 22,
                            )
                          : null,
                    ),
                    const SizedBox(height: 18),

                    // Field 2: Password
                    CustomAuthTextField(
                      label: 'Password',
                      hintText: 'Create your password',
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _onSignInPressed(context),
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.authPrimary,
                        size: 22,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.authTextSecondary,
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Forgot Password? Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _onForgotPasswordPressed(context),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.authLink,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.authLink,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Sign In Main Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoginLoading
                            ? null
                            : () => _onSignInPressed(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.authPrimary,
                          foregroundColor: AppColors.white,
                          disabledBackgroundColor: AppColors.authPrimary
                              .withValues(alpha: 0.6),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: isLoginLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.2,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // "Or using other method"
                    const Center(
                      child: Text(
                        'Or using other method',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.authTextSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Google Sign In
                    SocialAuthButton(
                      provider: SocialProvider.google,
                      isLoading: isGoogleLoading,
                      onTap: () =>
                          context.read<LoginCubit>().signInWithGoogle(),
                    ),
                    const SizedBox(height: 14),

                    // Facebook Sign In
                    SocialAuthButton(
                      provider: SocialProvider.facebook,
                      isLoading: isFacebookLoading,
                      onTap: () =>
                          context.read<LoginCubit>().signInWithFacebook(),
                    ),
                    const SizedBox(height: 24),

                    // Don't have an account? Sign Up Link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.authTextSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.registerRoute,
                              );
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.authLink,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

