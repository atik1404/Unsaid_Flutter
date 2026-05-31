import 'package:bloc_test/bloc_test.dart';
import 'package:common/common.dart';
import 'package:domain/domain.dart';
import 'package:entity/entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:login/src/bloc/login_bloc.dart';
import 'package:login/src/bloc/login_event.dart';
import 'package:login/src/bloc/login_state.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late LoginUseCase loginUseCase;

  const validPhone = '01712345678';
  const validPassword = 'secret123';
  const formattedPhone = '+8801712345678';

  final successEntity = LoginEntity(
    accessToken: 'access_token',
    refreshToken: 'refresh_token',
    expireDate: '2025-12-31',
  );

  setUpAll(() {
    registerFallbackValue(const LoginParams(identifier: '', password: ''));
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  group('LoginBloc', () {
    test('initial state is LoginState()', () {
      final bloc = LoginBloc(loginUseCase: loginUseCase);
      expect(bloc.state, const LoginState());
      bloc.close();
    });

    group('LoginPhoneChanged', () {
      blocTest<LoginBloc, LoginState>(
        'emits updated phone field',
        build: () => LoginBloc(loginUseCase: loginUseCase),
        act: (bloc) => bloc.add(const LoginPhoneChanged(validPhone)),
        expect: () => const [
          LoginState(phone: PhoneInputValidator.dirty(validPhone)),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'clears errorMessage when phone changes',
        build: () => LoginBloc(loginUseCase: loginUseCase),
        seed: () => const LoginState(
          phone: PhoneInputValidator.dirty(validPhone),
          password: PasswordInputValidator.dirty(validPassword),
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Invalid credentials',
        ),
        act: (bloc) => bloc.add(const LoginPhoneChanged('01712345679')),
        expect: () => const [
          LoginState(
            phone: PhoneInputValidator.dirty('01712345679'),
            password: PasswordInputValidator.dirty(validPassword),
            status: FormzSubmissionStatus.failure,
          ),
        ],
      );
    });

    group('LoginPasswordChanged', () {
      blocTest<LoginBloc, LoginState>(
        'emits updated password field',
        build: () => LoginBloc(loginUseCase: loginUseCase),
        act: (bloc) => bloc.add(const LoginPasswordChanged(validPassword)),
        expect: () => const [
          LoginState(password: PasswordInputValidator.dirty(validPassword)),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'clears errorMessage when password changes',
        build: () => LoginBloc(loginUseCase: loginUseCase),
        seed: () => const LoginState(
          phone: PhoneInputValidator.dirty(validPhone),
          password: PasswordInputValidator.dirty(validPassword),
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Invalid credentials',
        ),
        act: (bloc) => bloc.add(const LoginPasswordChanged('newPassword1')),
        expect: () => const [
          LoginState(
            phone: PhoneInputValidator.dirty(validPhone),
            password: PasswordInputValidator.dirty('newPassword1'),
            status: FormzSubmissionStatus.failure,
          ),
        ],
      );
    });

    group('LoginTogglePasswordVisibility', () {
      blocTest<LoginBloc, LoginState>(
        'toggles showPassword to true on first tap',
        build: () => LoginBloc(loginUseCase: loginUseCase),
        act: (bloc) => bloc.add(const LoginTogglePasswordVisibility()),
        expect: () => const [LoginState(showPassword: true)],
      );

      blocTest<LoginBloc, LoginState>(
        'toggles showPassword back to false on second tap',
        build: () => LoginBloc(loginUseCase: loginUseCase),
        act: (bloc) {
          bloc
            ..add(const LoginTogglePasswordVisibility())
            ..add(const LoginTogglePasswordVisibility());
        },
        expect: () => const [
          LoginState(showPassword: true),
          LoginState(),
        ],
      );
    });

    group('LoginSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        'emits showErrors with dirty-empty inputs and never calls repository',
        build: () => LoginBloc(loginUseCase: loginUseCase),
        act: (bloc) => bloc.add(const LoginSubmitted()),
        expect: () => const [
          LoginState(
            phone: PhoneInputValidator.dirty(),
            password: PasswordInputValidator.dirty(),
            showErrors: true,
          ),
        ],
        verify: (_) => verifyNever(() => mockAuthRepository.login(any())),
      );

      blocTest<LoginBloc, LoginState>(
        'emits showErrors when phone is too short and never calls repository',
        build: () => LoginBloc(loginUseCase: loginUseCase),
        seed: () => const LoginState(
          phone: PhoneInputValidator.dirty('0171'), // only 4 digits
          password: PasswordInputValidator.dirty(validPassword),
        ),
        act: (bloc) => bloc.add(const LoginSubmitted()),
        expect: () => const [
          LoginState(
            phone: PhoneInputValidator.dirty('0171'),
            password: PasswordInputValidator.dirty(validPassword),
            showErrors: true,
          ),
        ],
        verify: (_) => verifyNever(() => mockAuthRepository.login(any())),
      );

      blocTest<LoginBloc, LoginState>(
        'emits showErrors when password is too short and never calls repository',
        build: () => LoginBloc(loginUseCase: loginUseCase),
        seed: () => const LoginState(
          phone: PhoneInputValidator.dirty(validPhone),
          password: PasswordInputValidator.dirty('123'), // only 3 chars
        ),
        act: (bloc) => bloc.add(const LoginSubmitted()),
        expect: () => const [
          LoginState(
            phone: PhoneInputValidator.dirty(validPhone),
            password: PasswordInputValidator.dirty('123'),
            showErrors: true,
          ),
        ],
        verify: (_) => verifyNever(() => mockAuthRepository.login(any())),
      );

      blocTest<LoginBloc, LoginState>(
        'emits inProgress then success on valid credentials',
        build: () {
          when(() => mockAuthRepository.login(any())).thenAnswer((_) async => SuccessResult(successEntity));
          return LoginBloc(loginUseCase: loginUseCase);
        },
        act: (bloc) {
          bloc
            ..add(const LoginPhoneChanged(validPhone))
            ..add(const LoginPasswordChanged(validPassword))
            ..add(const LoginSubmitted());
        },
        expect: () => const [
          LoginState(phone: PhoneInputValidator.dirty(validPhone)),
          LoginState(
            phone: PhoneInputValidator.dirty(validPhone),
            password: PasswordInputValidator.dirty(validPassword),
          ),
          LoginState(
            phone: PhoneInputValidator.dirty(validPhone),
            password: PasswordInputValidator.dirty(validPassword),
            showErrors: true,
          ),
          LoginState(
            phone: PhoneInputValidator.dirty(validPhone),
            password: PasswordInputValidator.dirty(validPassword),
            showErrors: true,
            status: FormzSubmissionStatus.inProgress,
          ),
          LoginState(
            phone: PhoneInputValidator.dirty(validPhone),
            password: PasswordInputValidator.dirty(validPassword),
            showErrors: true,
            status: FormzSubmissionStatus.success,
          ),
        ],
        verify: (_) {
          final captured = verify(() => mockAuthRepository.login(captureAny())).captured;
          final params = captured.single as LoginParams;
          expect(params.identifier, formattedPhone);
          expect(params.password, validPassword);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'formats phone with +88 prefix before calling repository',
        build: () {
          when(() => mockAuthRepository.login(any())).thenAnswer((_) async => SuccessResult(successEntity));
          return LoginBloc(loginUseCase: loginUseCase);
        },
        seed: () => const LoginState(
          phone: PhoneInputValidator.dirty(validPhone),
          password: PasswordInputValidator.dirty(validPassword),
        ),
        act: (bloc) => bloc.add(const LoginSubmitted()),
        verify: (_) {
          final captured = verify(() => mockAuthRepository.login(captureAny())).captured;
          final params = captured.single as LoginParams;
          expect(params.identifier, formattedPhone);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits failure with raw message on ServerFailure',
        build: () {
          when(() => mockAuthRepository.login(any())).thenAnswer(
            (_) async => const FailureResult<LoginEntity, Failure>(
              ServerFailure('Invalid credentials', 401),
            ),
          );
          return LoginBloc(loginUseCase: loginUseCase);
        },
        act: (bloc) {
          bloc
            ..add(const LoginPhoneChanged(validPhone))
            ..add(const LoginPasswordChanged(validPassword))
            ..add(const LoginSubmitted());
        },
        expect: () => const [
          LoginState(phone: PhoneInputValidator.dirty(validPhone)),
          LoginState(
            phone: PhoneInputValidator.dirty(validPhone),
            password: PasswordInputValidator.dirty(validPassword),
          ),
          LoginState(
            phone: PhoneInputValidator.dirty(validPhone),
            password: PasswordInputValidator.dirty(validPassword),
            showErrors: true,
          ),
          LoginState(
            phone: PhoneInputValidator.dirty(validPhone),
            password: PasswordInputValidator.dirty(validPassword),
            showErrors: true,
            status: FormzSubmissionStatus.inProgress,
          ),
          LoginState(
            phone: PhoneInputValidator.dirty(validPhone),
            password: PasswordInputValidator.dirty(validPassword),
            showErrors: true,
            status: FormzSubmissionStatus.failure,
            errorMessage: 'Invalid credentials',
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits failure with locale key name on NetworkFailure',
        build: () {
          when(() => mockAuthRepository.login(any())).thenAnswer(
            (_) async => const FailureResult<LoginEntity, Failure>(
              NetworkFailure(FailureKey.network, 503),
            ),
          );
          return LoginBloc(loginUseCase: loginUseCase);
        },
        act: (bloc) {
          bloc
            ..add(const LoginPhoneChanged(validPhone))
            ..add(const LoginPasswordChanged(validPassword))
            ..add(const LoginSubmitted());
        },
        expect: () => const [
          LoginState(phone: PhoneInputValidator.dirty(validPhone)),
          LoginState(
            phone: PhoneInputValidator.dirty(validPhone),
            password: PasswordInputValidator.dirty(validPassword),
          ),
          LoginState(
            phone: PhoneInputValidator.dirty(validPhone),
            password: PasswordInputValidator.dirty(validPassword),
            showErrors: true,
          ),
          LoginState(
            phone: PhoneInputValidator.dirty(validPhone),
            password: PasswordInputValidator.dirty(validPassword),
            showErrors: true,
            status: FormzSubmissionStatus.inProgress,
          ),
          LoginState(
            phone: PhoneInputValidator.dirty(validPhone),
            password: PasswordInputValidator.dirty(validPassword),
            showErrors: true,
            status: FormzSubmissionStatus.failure,
            errorMessage: 'network', // FailureKey.network.name
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'isLoading is true only while status is inProgress',
        build: () {
          when(() => mockAuthRepository.login(any())).thenAnswer((_) async => SuccessResult(successEntity));
          return LoginBloc(loginUseCase: loginUseCase);
        },
        seed: () => const LoginState(
          phone: PhoneInputValidator.dirty(validPhone),
          password: PasswordInputValidator.dirty(validPassword),
        ),
        act: (bloc) => bloc.add(const LoginSubmitted()),
        expect: () => [
          isA<LoginState>().having((s) => s.isLoading, 'isLoading', false),
          isA<LoginState>().having((s) => s.isLoading, 'isLoading', true),
          isA<LoginState>().having((s) => s.isLoading, 'isLoading', false),
        ],
      );
    });
  });
}

class MockAuthRepository extends Mock implements AuthRepository {}
