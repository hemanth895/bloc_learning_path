import 'package:bloc_learning_path/Strings.dart';
import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController emailController;

  const EmailTextField({super.key, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: const InputDecoration(
        hintText: enterYourEmailHere,
      ),
    );
  }
}
