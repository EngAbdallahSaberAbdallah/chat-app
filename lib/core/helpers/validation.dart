import 'package:chat_app/core/constants/string_manager.dart';

class ValidationHelper {
  static String? validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value!)) {
      return StringsManager.validEmail;
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password!.isEmpty) {
      return StringsManager.enterYourPassword;
    } else if (password.length < 8) {
      return StringsManager.passwordValidation;
    } else {
      return null;
    }
  }

  static String? validateIsNotEmpty(String? v) =>
      v!.isEmpty ? StringsManager.fieldCannotBeEmpty : null;
}
