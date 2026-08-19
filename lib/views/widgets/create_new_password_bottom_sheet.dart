import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/view_models/login_cubit/login_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_snack_bar.dart';

Future<void> showCreateNewPasswordBottomSheet({
  required BuildContext context,
  required LoginCubit loginCubit,
  void Function(String newPassword)? onPasswordChanged,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.transparent,
    barrierColor: AppColors.black.withValues(alpha: 0.5),
    builder: (modalContext) => BlocProvider.value(
      value: loginCubit,
      child: CreateNewPasswordBottomSheet(
        onPasswordChanged: onPasswordChanged,
      ),
    ),
  );
}

class CreateNewPasswordBottomSheet extends StatefulWidget {
  final void Function(String newPassword)? onPasswordChanged;

  const CreateNewPasswordBottomSheet({
    super.key,
    this.onPasswordChanged,
  });

  @override
  State<CreateNewPasswordBottomSheet> createState() =>
      _CreateNewPasswordBottomSheetState();
}

class _CreateNewPasswordBottomSheetState
    extends State<CreateNewPasswordBottomSheet> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword(BuildContext context) {
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;
    final cubit = context.read<LoginCubit>();

    if (newPass.isEmpty) {
      CustomSnackBar.show(
        context,
        message: 'Please enter your new password',
        type: SnackBarType.error,
      );
      return;
    }

    if (newPass.length < 6) {
      CustomSnackBar.show(
        context,
        message: 'Password must be at least 6 characters long',
        type: SnackBarType.error,
      );
      return;
    }

    if (confirmPass.isEmpty) {
      CustomSnackBar.show(
        context,
        message: 'Please confirm your new password',
        type: SnackBarType.error,
      );
      return;
    }

    if (newPass != confirmPass) {
      CustomSnackBar.show(
        context,
        message: 'Passwords do not match',
        type: SnackBarType.error,
      );
      return;
    }

    cubit.changePassword(
      newPassword: newPass,
      confirmPassword: confirmPass,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is PasswordChangeFailure) {
          CustomSnackBar.show(
            context,
            message: state.errorMessage,
            type: SnackBarType.error,
          );
        } else if (state is PasswordChangedSuccess) {
          final newPassword = _newPasswordController.text;
          widget.onPasswordChanged?.call(newPassword);

          Navigator.of(context).pop(); // Close create new password sheet

          CustomSnackBar.show(
            context,
            message: state.message,
            type: SnackBarType.success,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ChangingPassword;

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
                'Create New Password',
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
                'Enter your new password and confirm it',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.authTextSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),

              // Field 1: New Password
              const Text(
                'Password',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.authTextDark,
                ),
              ),
              const SizedBox(height: 8),
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
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.authTextDark,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Create your password',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: AppColors.authTextSecondary.withValues(alpha: 0.7),
                      fontWeight: FontWeight.normal,
                    ),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.authPrimary,
                        size: 22,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.authTextSecondary,
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
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
              const SizedBox(height: 18),

              // Field 2: Confirm Password
              const Text(
                'Password',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.authTextDark,
                ),
              ),
              const SizedBox(height: 8),
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
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleChangePassword(context),
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.authTextDark,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Confirm your password',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: AppColors.authTextSecondary.withValues(alpha: 0.7),
                      fontWeight: FontWeight.normal,
                    ),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.authPrimary,
                        size: 22,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.authTextSecondary,
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
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

              // Change Password Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed:
                      isLoading ? null : () => _handleChangePassword(context),
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
                          'Change Password',
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
