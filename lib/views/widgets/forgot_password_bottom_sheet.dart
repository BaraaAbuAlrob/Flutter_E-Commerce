import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/view_models/login_cubit/login_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/create_new_password_bottom_sheet.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_snack_bar.dart';

Future<void> showForgotPasswordBottomSheet({
  required BuildContext context,
  required LoginCubit loginCubit,
  String initialValue = '',
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.transparent,
    barrierColor: AppColors.black.withValues(alpha: 0.5),
    builder: (modalContext) => BlocProvider.value(
      value: loginCubit,
      child: ForgotPasswordBottomSheet(initialValue: initialValue),
    ),
  );
}

class ForgotPasswordBottomSheet extends StatefulWidget {
  final String initialValue;

  const ForgotPasswordBottomSheet({
    super.key,
    this.initialValue = '',
  });

  @override
  State<ForgotPasswordBottomSheet> createState() =>
      _ForgotPasswordBottomSheetState();
}

class _ForgotPasswordBottomSheetState extends State<ForgotPasswordBottomSheet> {
  late final TextEditingController _emailController;
  bool _isValidEmail = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialValue);
    _checkValidation(_emailController.text);
  }

  void _checkValidation(String value) {
    final cubit = context.read<LoginCubit>();
    final isValid = cubit.isValidEmail(value.trim());
    if (isValid != _isValidEmail) {
      setState(() {
        _isValidEmail = isValid;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendCode(BuildContext context) {
    final emailText = _emailController.text.trim();
    final cubit = context.read<LoginCubit>();

    if (emailText.isEmpty) {
      CustomSnackBar.show(
        context,
        message: 'Please enter your email',
        type: SnackBarType.error,
      );
      return;
    }

    if (!_isValidEmail) {
      CustomSnackBar.show(
        context,
        message: 'Please enter a valid email address (e.g. name@mail.com)',
        type: SnackBarType.error,
      );
      return;
    }

    cubit.sendResetCode(email: emailText);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is ResetCodeFailure) {
          CustomSnackBar.show(
            context,
            message: state.errorMessage,
            type: SnackBarType.error,
          );
        } else if (state is ResetCodeSent) {
          Navigator.of(context).pop(); // Close forgot password sheet

          CustomSnackBar.show(
            context,
            message:
                'Reset link & verification code sent to ${state.email}!',
            type: SnackBarType.success,
          );

          // Automatically open Create New Password bottom sheet simulating clicking the reset link
          Future.delayed(const Duration(milliseconds: 300), () {
            if (context.mounted) {
              final cubit = context.read<LoginCubit>();
              showCreateNewPasswordBottomSheet(
                context: context,
                loginCubit: cubit,
              );
            }
          });
        }
      },
      builder: (context, state) {
        final isLoading = state is SendingResetCode;

        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28.0),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: mediaQuery.viewInsets.bottom + 24,
            top: 12,
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 44,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                'Forgot Password',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.authTextDark,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),

              // Subtitle
              const Text(
                'Enter your email address to receive a verification link',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.authTextSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),

              // Field Label
              const Text(
                'Email',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.authTextDark,
                ),
              ),
              const SizedBox(height: 8),

              // Input Container with live validation checkmark
              Container(
                decoration: BoxDecoration(
                  color: AppColors.authInputBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.authInputBorder,
                    width: 1.2,
                  ),
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onChanged: _checkValidation,
                  onSubmitted: (_) => _handleSendCode(context),
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.authTextDark,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: AppColors.authTextSecondary.withValues(alpha: 0.7),
                      fontWeight: FontWeight.normal,
                    ),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Icon(
                        Icons.mail_outline_rounded,
                        color: AppColors.authPrimary,
                        size: 22,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    suffixIcon: _isValidEmail
                        ? const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            child: Icon(
                              Icons.check_circle,
                              color: AppColors.authSuccess,
                              size: 22,
                            ),
                          )
                        : null,
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Send Code Action Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () => _handleSendCode(context),
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
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColors.white),
                          ),
                        )
                      : const Text(
                          'Send Code',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.2,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
