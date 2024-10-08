

part of 'user_cubit.dart';


@freezed
class UserState with _$UserState {
  const factory UserState.initial() = UserInitial;
  const factory UserState.loading() = UserLoading;
  const factory UserState.loaded(List<UserModel> users) = UserLoaded;
  const factory UserState.error(String message) = UserError;
}
