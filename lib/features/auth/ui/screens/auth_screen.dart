import 'package:chat_app/core/constants/shred_pref_constants.dart';
import 'package:chat_app/core/constants/string_manager.dart';
import 'package:chat_app/core/helpers/extentions.dart';
import 'package:chat_app/core/helpers/shared_pref_helper.dart';
import 'package:chat_app/core/helpers/validation.dart';
import 'package:chat_app/core/routing/routes.dart';
import 'package:chat_app/core/theming/colors.dart';
import 'package:chat_app/core/theming/styles.dart';
import 'package:chat_app/core/widgets/app_text_form_field.dart';
import 'package:chat_app/features/auth/logic/auth_cubit.dart';
import 'package:chat_app/features/home/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLogin = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(isLogin ? StringsManager.login : StringsManager.signUp)),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Navigate to HomeScreen
            context.pushReplacementNamed(Routes.homeScreen);
          } else if (state is Error) {
            // Show error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            return const Center(
                child: CircularProgressIndicator(
              color: ColorsManager.lightBlue,
            ));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  AppTextFormField(
                    backgroundColor: Colors.transparent,
                    hintText: StringsManager.email,
                    validator: (value) => value!.isEmpty
                        ? StringsManager.enterTheEmailAddress
                        : ValidationHelper.validateEmail(value),
                    controller: _emailController,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  AppTextFormField(
                      // isObscureText: true,
                      backgroundColor: Colors.transparent,
                      controller: _passwordController,
                      hintText: StringsManager.password,
                      validator: (value) => value!.isEmpty
                          ? StringsManager.enterYourPassword
                          : ValidationHelper.validatePassword(value)),
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
                    child: Text(
                      isLogin ? StringsManager.login : StringsManager.signUp,
                      style: TextStyles.font13BlueRegular,
                    ),
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
                          ? StringsManager.doNotHaveAccount
                          : StringsManager.alreadyHaveAnAccount,
                      style: TextStyles.font13BlueRegular,
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
