import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models/register_cubit/register_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_auth_text_field.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_snack_bar.dart';
import 'package:flutter_ecommerce_app/views/widgets/social_auth_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
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
    final cubit = context.read<RegisterCubit>();
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
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onCreateAccountPressed(BuildContext context) {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final cubit = context.read<RegisterCubit>();

    if (username.isEmpty) {
      CustomSnackBar.show(
        context,
        message: 'Please enter your username',
        type: SnackBarType.error,
      );
      return;
    }

    if (username.length < 3) {
      CustomSnackBar.show(
        context,
        message: 'Username must be at least 3 characters',
        type: SnackBarType.error,
      );
      return;
    }

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

    cubit.signUp(
      username: username,
      email: email,
      password: password,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterFailure) {
              CustomSnackBar.show(
                context,
                message: state.errorMessage,
                type: SnackBarType.error,
              );
            } else if (state is RegisterSuccess) {
              CustomSnackBar.show(
                context,
                message: state.message,
                type: SnackBarType.success,
              );
              Navigator.of(context).pushReplacementNamed(AppRoutes.homePage);
            } else if (state is SocialRegisterSuccess) {
              CustomSnackBar.show(
                context,
                message: state.message,
                type: SnackBarType.success,
              );
              Navigator.of(context).pushReplacementNamed(AppRoutes.homePage);
            } else if (state is SocialRegisterFailure) {
              CustomSnackBar.show(
                context,
                message: state.errorMessage,
                type: SnackBarType.error,
              );
            }
          },
          builder: (context, state) {
            final isRegisterLoading = state is RegisterLoading;
            final isGoogleLoading =
                state is SocialRegisterLoading && state.provider == 'Google';
            final isFacebookLoading =
                state is SocialRegisterLoading && state.provider == 'Facebook';

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 28),

                  // Header: Create Account
                  const Text(
                    'Create Account',
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
                    'Start learning with create your account',
                    style: TextStyle(
                      fontSize: 14.5,
                      color: AppColors.authTextSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Field 1: Username
                  CustomAuthTextField(
                    label: 'Username',
                    hintText: 'Enter your username',
                    controller: _usernameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.authPrimary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Field 2: Email with Live Validation Indicator
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

                  // Field 3: Password
                  CustomAuthTextField(
                    label: 'Password',
                    hintText: 'Create your password',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _onCreateAccountPressed(context),
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
                  const SizedBox(height: 28),

                  // Create Account Main Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isRegisterLoading
                          ? null
                          : () => _onCreateAccountPressed(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.authPrimary,
                        foregroundColor: AppColors.white,
                        disabledBackgroundColor:
                            AppColors.authPrimary.withValues(alpha: 0.6),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: isRegisterLoading
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
                              'Create Account',
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

                  // Google Sign Up
                  SocialAuthButton(
                    provider: SocialProvider.google,
                    isSignUp: true,
                    isLoading: isGoogleLoading,
                    onTap: () =>
                        context.read<RegisterCubit>().signUpWithGoogle(),
                  ),
                  const SizedBox(height: 14),

                  // Facebook Sign Up
                  SocialAuthButton(
                    provider: SocialProvider.facebook,
                    isSignUp: true,
                    isLoading: isFacebookLoading,
                    onTap: () =>
                        context.read<RegisterCubit>().signUpWithFacebook(),
                  ),
                  const SizedBox(height: 24),

                  // Already have an account? Sign In Link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.authTextSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            } else {
                              Navigator.of(context).pushReplacementNamed(
                                AppRoutes.loginRoute,
                              );
                            }
                          },
                          child: const Text(
                            'Sign In',
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
    );
  }
}
