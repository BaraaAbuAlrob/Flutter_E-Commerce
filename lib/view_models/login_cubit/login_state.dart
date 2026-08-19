part of 'login_cubit.dart';

sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final String email;
  final String message;

  LoginSuccess({
    required this.email,
    this.message = 'Logged in successfully!',
  });

  String get emailOrPhone => email;
}

final class LoginFailure extends LoginState {
  final String errorMessage;

  LoginFailure(this.errorMessage);
}

final class SendingResetCode extends LoginState {}

final class ResetCodeSent extends LoginState {
  final String email;
  final String message;

  ResetCodeSent({
    required this.email,
    this.message = 'Reset code and link sent successfully!',
  });

  String get emailOrPhone => email;
}

final class ResetCodeFailure extends LoginState {
  final String errorMessage;

  ResetCodeFailure(this.errorMessage);
}

final class ChangingPassword extends LoginState {}

final class PasswordChangedSuccess extends LoginState {
  final String message;

  PasswordChangedSuccess({
    this.message = 'Password has been changed successfully!',
  });
}

final class PasswordChangeFailure extends LoginState {
  final String errorMessage;

  PasswordChangeFailure(this.errorMessage);
}

final class SocialLoginLoading extends LoginState {
  final String provider;

  SocialLoginLoading(this.provider);
}

final class SocialLoginSuccess extends LoginState {
  final String provider;
  final String message;

  SocialLoginSuccess({
    required this.provider,
    required this.message,
  });
}

final class SocialLoginFailure extends LoginState {
  final String provider;
  final String errorMessage;

  SocialLoginFailure({
    required this.provider,
    required this.errorMessage,
  });
}

