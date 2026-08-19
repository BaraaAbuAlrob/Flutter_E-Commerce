import 'package:flutter_ecommerce_app/view_models/register_cubit/register_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RegisterCubit Tests', () {
    late RegisterCubit cubit;

    setUp(() {
      cubit = RegisterCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is RegisterInitial', () {
      expect(cubit.state, isA<RegisterInitial>());
    });

    test('validates correct email formats properly', () {
      expect(cubit.isValidEmail('magdalena83@mail.com'), isTrue);
      expect(cubit.isValidEmail('user@gmail.com'), isTrue);
      expect(cubit.isValidEmail('john.doe@company.org'), isTrue);
    });

    test('rejects invalid email formats properly', () {
      expect(cubit.isValidEmail(''), isFalse);
      expect(cubit.isValidEmail('magdalena83@mai'), isFalse);
      expect(cubit.isValidEmail('magdalena83@'), isFalse);
      expect(cubit.isValidEmail('@mail.com'), isFalse);
      expect(cubit.isValidEmail('magdalena83@.com'), isFalse);
      expect(cubit.isValidEmail('1234567890'), isFalse);
    });

    test('signUp with empty username emits RegisterFailure', () async {
      await cubit.signUp(
        username: '',
        email: 'magdalena83@mail.com',
        password: 'password123',
      );
      expect(cubit.state, isA<RegisterFailure>());
      expect(
        (cubit.state as RegisterFailure).errorMessage,
        'Please enter your username',
      );
    });

    test('signUp with short username emits RegisterFailure', () async {
      await cubit.signUp(
        username: 'ab',
        email: 'magdalena83@mail.com',
        password: 'password123',
      );
      expect(cubit.state, isA<RegisterFailure>());
      expect(
        (cubit.state as RegisterFailure).errorMessage,
        'Username must be at least 3 characters',
      );
    });

    test('signUp with invalid email emits RegisterFailure', () async {
      await cubit.signUp(
        username: 'Magdalena',
        email: 'magdalena83@mai',
        password: 'password123',
      );
      expect(cubit.state, isA<RegisterFailure>());
      expect(
        (cubit.state as RegisterFailure).errorMessage,
        'Please enter a valid email address (e.g. name@mail.com)',
      );
    });

    test('signUp with short password emits RegisterFailure', () async {
      await cubit.signUp(
        username: 'Magdalena',
        email: 'magdalena83@mail.com',
        password: '123',
      );
      expect(cubit.state, isA<RegisterFailure>());
      expect(
        (cubit.state as RegisterFailure).errorMessage,
        'Password must be at least 6 characters',
      );
    });

    test('signUp with valid data emits RegisterSuccess', () async {
      await cubit.signUp(
        username: 'Magdalena Succrose',
        email: 'magdalena83@mail.com',
        password: 'magdalenasucrose83',
      );
      expect(cubit.state, isA<RegisterSuccess>());
      final success = cubit.state as RegisterSuccess;
      expect(success.username, 'Magdalena Succrose');
      expect(success.email, 'magdalena83@mail.com');
    });

    test('signUpWithGoogle emits SocialRegisterSuccess', () async {
      await cubit.signUpWithGoogle();
      expect(cubit.state, isA<SocialRegisterSuccess>());
      expect((cubit.state as SocialRegisterSuccess).provider, 'Google');
    });

    test('signUpWithFacebook emits SocialRegisterSuccess', () async {
      await cubit.signUpWithFacebook();
      expect(cubit.state, isA<SocialRegisterSuccess>());
      expect((cubit.state as SocialRegisterSuccess).provider, 'Facebook');
    });
  });
}
