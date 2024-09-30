import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/features/auth/ui/screens/login_screen.dart';
import 'package:chat_app/features/auth/ui/screens/sign_up_screen.dart';
import 'package:chat_app/features/home/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../di/dependency_injection.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
                  );
      case Routes.signUpScreen:
        return MaterialPageRoute(
          builder: (_) => SignUpScreen(),
        
        );
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) =>  HomeScreen(),
          
        );
        case Routes.chatScreen:
        return MaterialPageRoute(
          builder: (_) =>HomeScreen(),
          
        );
      default:
        return null;
    }
  }
}
