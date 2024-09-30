import 'package:chat_app/core/di/dependency_injection.dart';
import 'package:chat_app/core/resources/bloc_provider_manager.dart';
import 'package:chat_app/core/theming/app_theme.dart';
import 'package:chat_app/features/auth/ui/screens/auth_screen.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupLocator();
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: blocProviderList,
        child: ScreenUtilInit(
          useInheritedMediaQuery: true,
          designSize: const Size(375, 829),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Chat App',
              theme: AppTheme.darkTheme,
              home: AuthScreen()),
        ));
  }
}
