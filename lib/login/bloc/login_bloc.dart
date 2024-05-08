import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:blocprojects/login/model/models.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository _authenticationRepository;
  LoginBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<LoginEvent>((event, emit) {
      on<LoginUserNameChange>(_onLoginUserNameChange);
      on<LoginPasswordChange>(_onLoginPasswordChange);
      on<LoginSubmitted>(_onLoginSubmitted);
    });
  }

  void _onLoginUserNameChange(
      LoginUserNameChange event, Emitter<LoginState> emit) {
    final Username userName = Username.dirty(event.userName);
    emit(state.copyWith(
        username: userName,
        isValid: Formz.validate([state.password, userName])));
  }

  void _onLoginPasswordChange(
      LoginPasswordChange event, Emitter<LoginState> emit) {
    final Password password = Password.dirty(event.password);
    emit(state.copyWith(
        username: state.username,
        isValid: Formz.validate([state.username, password])));
  }

  void _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _authenticationRepository.login(
            userName: state.username.value, password: state.password.value);
      } catch (e) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}
