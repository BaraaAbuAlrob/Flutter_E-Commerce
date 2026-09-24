import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/secrvices/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository.instance,
        super(LoginInitial());

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
    try {
      await _authRepository.signInWithEmail(
        email: trimmedEmail,
        password: password,
      );
      emit(
        LoginSuccess(
          email: trimmedEmail,
          message: 'Welcome back! Logged in successfully.',
        ),
      );
    } on AuthException catch (e) {
      emit(LoginFailure(e.message));
    } catch (_) {
      emit(LoginFailure('خطأ غير معروف أثناء تسجيل الدخول'));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(SocialLoginLoading('Google'));
    try {
      await _authRepository.signInWithGoogle();
      emit(SocialLoginSuccess(provider: 'Google', message: 'Signed in with Google successfully!'));
    } on AuthException catch (e) {
      emit(SocialLoginFailure(provider: 'Google', errorMessage: e.message));
    } catch (e) {
      emit(SocialLoginFailure(provider: 'Google', errorMessage: 'خطأ غير معروف أثناء تسجيل الدخول عبر Google'));
    }
  }

  Future<void> signInWithFacebook() async {
    emit(SocialLoginLoading('Facebook'));
    try {
      await _authRepository.signInWithFacebook();
      emit(SocialLoginSuccess(provider: 'Facebook', message: 'Signed in with Facebook successfully!'));
    } on AuthException catch (e) {
      emit(SocialLoginFailure(provider: 'Facebook', errorMessage: e.message));
    } catch (e) {
      emit(SocialLoginFailure(provider: 'Facebook', errorMessage: 'خطأ غير معروف أثناء تسجيل الدخول عبر Facebook'));
    }
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

