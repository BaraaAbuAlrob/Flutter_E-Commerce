import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

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
    await Future.delayed(const Duration(milliseconds: 1000));

    emit(
      RegisterSuccess(
        username: trimmedUsername,
        email: trimmedEmail,
        message: 'Account created successfully! Welcome aboard.',
      ),
    );
  }

  Future<void> signUpWithGoogle() async {
    emit(SocialRegisterLoading('Google'));
    await Future.delayed(const Duration(milliseconds: 900));
    emit(
      SocialRegisterSuccess(
        provider: 'Google',
        message: 'Signed up with Google successfully!',
      ),
    );
  }

  Future<void> signUpWithFacebook() async {
    emit(SocialRegisterLoading('Facebook'));
    await Future.delayed(const Duration(milliseconds: 900));
    emit(
      SocialRegisterSuccess(
        provider: 'Facebook',
        message: 'Signed up with Facebook successfully!',
      ),
    );
  }
}
