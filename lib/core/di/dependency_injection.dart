// service_locator.dart
import 'package:chat_app/features/auth/data/repos/auth_repo.dart';
import 'package:chat_app/features/auth/logic/auth_cubit.dart';
import 'package:chat_app/features/chat/data/repos/chat_repo.dart';
import 'package:chat_app/features/chat/logic/chat_cubit.dart';
import 'package:chat_app/features/home/data/repos/users_repo.dart';
import 'package:chat_app/features/home/logic/cubit/user_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {

  // Repositories
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo());
  getIt.registerLazySingleton<ChatRepo>(() => ChatRepo());
  getIt.registerLazySingleton<UserRepo>(() => UserRepo());

  // Cubits
  getIt.registerFactory<AuthCubit>(
      () => AuthCubit(getIt<AuthRepo>()));
  getIt.registerFactory<ChatCubit>(() => ChatCubit(getIt<ChatRepo>()));
  getIt.registerFactory<UserCubit>(() => UserCubit(getIt<UserRepo>()));

}
