import 'package:bloc_learning_path/views/email_text_field.dart';
import 'package:bloc_learning_path/views/login_button.dart';
import 'package:bloc_learning_path/views/password_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginView extends HookWidget {
  final OnLoginTapped onLoginTapped;

  const LoginView({
    Key? key,
    required this.onLoginTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          EmailTextField(emailController: emailController),
          PasswordTextField(passwordController: passwordController),
          LoginButton(emailController: emailController, passwordController: passwordController, onLoginTapped: onLoginTapped)
        ],
      ),
    );
  }
}
