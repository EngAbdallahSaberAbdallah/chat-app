import 'package:chat_app/core/di/dependency_injection.dart';
import 'package:chat_app/features/auth/logic/auth_cubit.dart';
import 'package:chat_app/features/chat/logic/chat_cubit.dart';
import 'package:chat_app/features/home/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? "Login" : "Sign Up")),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Navigate to HomeScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<ChatCubit>(
                      create: (_) => getIt<ChatCubit>(),
                    ),
                    // Add other BlocProviders if necessary
                  ],
                  child: HomeScreen(),
                ),
              ),
            );
          } else if (state is Error) {
            // Show error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (isLogin) {
                        context.read<AuthCubit>().signIn(
                              _emailController.text,
                              _passwordController.text,
                            );
                      } else {
                        context.read<AuthCubit>().signUp(
                              _emailController.text,
                              _passwordController.text,
                            );
                      }
                    },
                    child: Text(isLogin ? "Login" : "Sign Up"),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin
                          ? "Don't have an account? Sign Up"
                          : "Already have an account? Login",
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
