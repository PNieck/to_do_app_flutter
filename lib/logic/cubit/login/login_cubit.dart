import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:to_do_app_flutter/data/repositories/user_repository.dart';

import '../../../data/models/user.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  late StreamSubscription authStateStream;
  UserRepository userRepository;

  LoginCubit()
      : userRepository = UserRepository(),
        super(LoginInitialState()) {
    authStateStream = userRepository.userStateStream.listen((user) {
      if (user == null) {
        emit(NotLoggedIn());
      } else {
        emit(LoggedIn(user));
      }
    });
  }

  @override
  Future<void> close() {
    authStateStream.cancel();
    return super.close();
  }
}
