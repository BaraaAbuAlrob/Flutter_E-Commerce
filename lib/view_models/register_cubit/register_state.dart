part of 'register_cubit.dart';

sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final String username;
  final String email;
  final String message;

  RegisterSuccess({
    required this.username,
    required this.email,
    this.message = 'Account created successfully! Welcome aboard.',
  });
}

final class RegisterFailure extends RegisterState {
  final String errorMessage;

  RegisterFailure(this.errorMessage);
}

final class SocialRegisterLoading extends RegisterState {
  final String provider;

  SocialRegisterLoading(this.provider);
}

final class SocialRegisterSuccess extends RegisterState {
  final String provider;
  final String message;

  SocialRegisterSuccess({
    required this.provider,
    required this.message,
  });
}

final class SocialRegisterFailure extends RegisterState {
  final String provider;
  final String errorMessage;

  SocialRegisterFailure({
    required this.provider,
    required this.errorMessage,
  });
}
