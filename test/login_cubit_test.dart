import 'package:flutter_ecommerce_app/view_models/login_cubit/login_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginCubit Email Validation Tests', () {
    late LoginCubit cubit;

    setUp(() {
      cubit = LoginCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('validates correct email formats properly', () {
      expect(cubit.isValidEmail('user@gmail.com'), isTrue);
      expect(cubit.isValidEmail('john.doe@company.org'), isTrue);
      expect(cubit.isValidEmail('support+test@domain.io'), isTrue);
      expect(cubit.isValidEmail('admin@sub.domain.net'), isTrue);
    });

    test('rejects invalid email formats properly', () {
      expect(cubit.isValidEmail(''), isFalse);
      expect(cubit.isValidEmail('plainaddress'), isFalse);
      expect(cubit.isValidEmail('user@'), isFalse);
      expect(cubit.isValidEmail('user@domain'), isFalse);
      expect(cubit.isValidEmail('@domain.com'), isFalse);
      expect(cubit.isValidEmail('user@.com'), isFalse);
      expect(cubit.isValidEmail('1234567890'), isFalse);
      expect(cubit.isValidEmail('+1234567890'), isFalse);
    });

    test('signIn with invalid email emits LoginFailure', () async {
      await cubit.signIn(email: 'invalid_email', password: 'password123');
      expect(cubit.state, isA<LoginFailure>());
      expect(
        (cubit.state as LoginFailure).errorMessage,
        'Please enter a valid email address (e.g. name@mail.com)',
      );
    });

    test('signIn with valid email and password emits LoginSuccess', () async {
      await cubit.signIn(email: 'user@test.com', password: 'password123');
      expect(cubit.state, isA<LoginSuccess>());
      expect((cubit.state as LoginSuccess).email, 'user@test.com');
    });

    test('sendResetCode with invalid email emits ResetCodeFailure', () async {
      await cubit.sendResetCode(email: 'not_an_email');
      expect(cubit.state, isA<ResetCodeFailure>());
      expect(
        (cubit.state as ResetCodeFailure).errorMessage,
        'Please enter a valid email address (e.g. name@mail.com)',
      );
    });

    test('sendResetCode with valid email emits ResetCodeSent', () async {
      await cubit.sendResetCode(email: 'user@test.com');
      expect(cubit.state, isA<ResetCodeSent>());
      expect((cubit.state as ResetCodeSent).email, 'user@test.com');
    });
  });
}
