import 'package:chat_app/core/di/dependency_injection.dart';
import 'package:chat_app/features/auth/logic/auth_cubit.dart';
import 'package:chat_app/features/chat/logic/chat_cubit.dart';
import 'package:chat_app/features/home/logic/cubit/user_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get blocProviderList {
  return [
     
     BlocProvider(create: (context) =>getIt<AuthCubit>()),
     BlocProvider(create: (context) =>getIt<UserCubit>()),
     BlocProvider(create: (context) =>getIt<ChatCubit>()),

  ];}