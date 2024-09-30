import 'package:chat_app/core/di/dependency_injection.dart';
import 'package:chat_app/core/theming/app_theme.dart';
import 'package:chat_app/features/auth/ui/screens/auth_screen.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main()async {
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform
  );
  setupLocator();
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',  
      theme: AppTheme.darkTheme,
      home:AuthScreen()
    );
  }
}
