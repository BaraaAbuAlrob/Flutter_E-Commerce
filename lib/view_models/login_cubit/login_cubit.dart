import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  // Strict email regex validator: checks username, @, domain/provider, and TLD
  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  bool isValidEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return false;
    return _emailRegex.hasMatch(trimmed);
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      emit(LoginFailure('Please enter your email'));
      return;
    }
    if (!isValidEmail(trimmedEmail)) {
      emit(
        LoginFailure(
          'Please enter a valid email address (e.g. name@mail.com)',
        ),
      );
      return;
    }
    if (password.isEmpty) {
      emit(LoginFailure('Please enter your password'));
      return;
    }
    if (password.length < 6) {
      emit(LoginFailure('Password must be at least 6 characters'));
      return;
    }

    emit(LoginLoading());
    // Simulate authentication API call
    await Future.delayed(const Duration(milliseconds: 1000));

    emit(
      LoginSuccess(
        email: trimmedEmail,
        message: 'Welcome back! Logged in successfully.',
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(SocialLoginLoading('Google'));
    await Future.delayed(const Duration(milliseconds: 900));
    emit(
      SocialLoginSuccess(
        provider: 'Google',
        message: 'Signed in with Google successfully!',
      ),
    );
  }

  Future<void> signInWithFacebook() async {
    emit(SocialLoginLoading('Facebook'));
    await Future.delayed(const Duration(milliseconds: 900));
    emit(
      SocialLoginSuccess(
        provider: 'Facebook',
        message: 'Signed in with Facebook successfully!',
      ),
    );
  }

  Future<void> sendResetCode({
    required String email,
  }) async {
    final trimmed = email.trim();
    if (trimmed.isEmpty) {
      emit(ResetCodeFailure('Please enter your email'));
      return;
    }
    if (!isValidEmail(trimmed)) {
      emit(
        ResetCodeFailure(
          'Please enter a valid email address (e.g. name@mail.com)',
        ),
      );
      return;
    }

    emit(SendingResetCode());
    await Future.delayed(const Duration(milliseconds: 1100));

    emit(
      ResetCodeSent(
        email: trimmed,
        message: 'Reset code and password reset link sent to $trimmed',
      ),
    );
  }

  Future<void> changePassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (newPassword.isEmpty) {
      emit(PasswordChangeFailure('Please enter your new password'));
      return;
    }
    if (newPassword.length < 6) {
      emit(
        PasswordChangeFailure('Password must be at least 6 characters long'),
      );
      return;
    }
    if (confirmPassword.isEmpty) {
      emit(PasswordChangeFailure('Please confirm your password'));
      return;
    }
    if (newPassword != confirmPassword) {
      emit(PasswordChangeFailure('Passwords do not match'));
      return;
    }

    emit(ChangingPassword());
    await Future.delayed(const Duration(milliseconds: 1100));

    emit(
      PasswordChangedSuccess(
        message: 'Password changed successfully! Please log in.',
      ),
    );
  }
}

