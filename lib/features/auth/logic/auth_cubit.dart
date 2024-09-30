import 'package:bloc/bloc.dart';
import 'package:chat_app/core/constants/shred_pref_constants.dart';
import 'package:chat_app/core/helpers/shared_pref_helper.dart';
import 'package:chat_app/features/auth/data/repos/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;
  AuthCubit(this._authRepo) : super(AuthState.initial());

  Future<void> signIn(String email, String password) async {
    emit(const AuthState.loading());
    try {
      final user = await _authRepo.signIn(email, password);
      emit(AuthState.authenticated(user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthState.error(e.message ?? 'Authentication Failed'));
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(const AuthState.loading());
    try {
      final user = await _authRepo.signUp(email, password);
    
      emit(AuthState.authenticated(user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthState.error(e.message ?? 'Sign Up Failed'));
    }
  }

  Future<void> signOut() async {
    emit(const AuthState.loading());
    await _authRepo.signOut();
    emit(const AuthState.unauthenticated());
  }
}
