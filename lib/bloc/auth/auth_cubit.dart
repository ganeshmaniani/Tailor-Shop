import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailor_shop/entities/login/login_entity.dart';

import '../../repository/auth/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  AuthCubit({required this.authRepository}) : super(AuthInitial());

  userLogin(LoginEntity loginEntity) async {
    try {
      emit(AuthLoading());
      bool response = await authRepository.userLogin(loginEntity);
      if (response) {
        emit(AuthSuccess());
      } else {
        emit(const AuthFailure(errorMessage: 'Please enter valid credentials'));
      }
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }
}
