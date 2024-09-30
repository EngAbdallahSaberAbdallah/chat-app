import 'package:bloc/bloc.dart';
import 'package:chat_app/features/home/data/models/user_model.dart';
import 'package:chat_app/features/home/data/repos/users_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_state.dart';
part 'user_cubit.freezed.dart'; // This generates the code for freezed

class UserCubit extends Cubit<UserState> {
  final UserRepo _userRepo;
  
  UserCubit(this._userRepo) : super(const UserState.initial());

  Future<void> fetchUsers() async {
    emit(const UserState.loading());
    final result = await _userRepo.fetchUsers();

    result.fold(
      (error) {
        emit(UserState.error(error.toString()));
      },
      (users) {
        emit(UserState.loaded(users));
      },
    );
  }
}
