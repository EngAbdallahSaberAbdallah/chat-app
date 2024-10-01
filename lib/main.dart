import 'package:chat_app/core/constants/shred_pref_constants.dart';
import 'package:chat_app/core/di/dependency_injection.dart';
import 'package:chat_app/core/helpers/shared_pref_helper.dart';
import 'package:chat_app/core/resources/bloc_provider_manager.dart';
import 'package:chat_app/core/routing/app_router.dart';
import 'package:chat_app/core/routing/routes.dart';
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
  await checkIfLoggedInUser();
  runApp(ChatApp(
    appRouter: AppRouter(),
  ));
}

checkIfLoggedInUser() async {
  isLoggedInUser = await SharedPrefHelper.getBool(SharedPrefKeys.isLoggedIn);
}

class ChatApp extends StatelessWidget {
  final AppRouter appRouter;
  const ChatApp({super.key, required this.appRouter});

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
              initialRoute:
                  isLoggedInUser ? Routes.homeScreen : Routes.authScreen,
              onGenerateRoute: appRouter.generateRoute,
              title: 'Chat App',
              theme: AppTheme.darkTheme,
              home: AuthScreen()),
        ));
  }
}
