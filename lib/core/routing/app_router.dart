import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/features/auth/ui/screens/auth_screen.dart';
import 'package:chat_app/features/home/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.authScreen:
        return MaterialPageRoute(
          builder: (_) => AuthScreen(),
        );

      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      case Routes.chatScreen:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      default:
        return null;
    }
  }
}
