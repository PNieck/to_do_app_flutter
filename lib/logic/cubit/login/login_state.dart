part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoggedIn extends LoginState {
  final AppUser user;

  LoggedIn(this.user);
}

class NotLoggedIn extends LoginState {}
