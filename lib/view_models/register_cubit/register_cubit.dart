import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/secrvices/auth_repository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;

  RegisterCubit({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository.instance,
        super(RegisterInitial());

  // Strict email regex validator: checks username, @, domain/provider, and TLD
  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  bool isValidEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return false;
    return _emailRegex.hasMatch(trimmed);
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    final trimmedUsername = username.trim();
    final trimmedEmail = email.trim();

    if (trimmedUsername.isEmpty) {
      emit(RegisterFailure('Please enter your username'));
      return;
    }
    if (trimmedUsername.length < 3) {
      emit(RegisterFailure('Username must be at least 3 characters'));
      return;
    }
    if (trimmedEmail.isEmpty) {
      emit(RegisterFailure('Please enter your email'));
      return;
    }
    if (!isValidEmail(trimmedEmail)) {
      emit(
        RegisterFailure(
          'Please enter a valid email address (e.g. name@mail.com)',
        ),
      );
      return;
    }
    if (password.isEmpty) {
      emit(RegisterFailure('Please enter your password'));
      return;
    }
    if (password.length < 6) {
      emit(RegisterFailure('Password must be at least 6 characters'));
      return;
    }

    emit(RegisterLoading());
    try {
      await _authRepository.signUpWithEmail(email: trimmedEmail, password: password, name: trimmedUsername);
      emit(RegisterSuccess(username: trimmedUsername, email: trimmedEmail, message: 'Account created successfully! Welcome aboard.'));
    } on AuthException catch (e) {
      emit(RegisterFailure(e.message));
    } catch (e) {
      emit(RegisterFailure('خطأ غير معروف أثناء إنشاء الحساب'));
    }
  }

  Future<void> signUpWithGoogle() async {
    emit(SocialRegisterLoading('Google'));
    try {
      await _authRepository.signInWithGoogle();
      emit(SocialRegisterSuccess(provider: 'Google', message: 'Signed up with Google successfully!'));
    } on AuthException catch (e) {
      emit(SocialRegisterFailure(provider: 'Google', errorMessage: e.message));
    } catch (_) {
      emit(SocialRegisterFailure(provider: 'Google', errorMessage: 'خطأ غير معروف أثناء تسجيل الحساب عبر Google'));
    }
  }

  Future<void> signUpWithFacebook() async {
    emit(SocialRegisterLoading('Facebook'));
    try {
      await _authRepository.signInWithFacebook();
      emit(SocialRegisterSuccess(provider: 'Facebook', message: 'Signed up with Facebook successfully!'));
    } on AuthException catch (e) {
      emit(SocialRegisterFailure(provider: 'Facebook', errorMessage: e.message));
    } catch (_) {
      emit(SocialRegisterFailure(provider: 'Facebook', errorMessage: 'خطأ غير معروف أثناء تسجيل الحساب عبر Facebook'));
    }
  }
}
