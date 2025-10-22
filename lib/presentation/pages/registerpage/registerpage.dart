import 'package:flutter/material.dart';
import 'package:nubo/presentation/views/login/register_view.dart';

class RegisterFormPage extends StatelessWidget {
  static const String name = "register_form_page";
  const RegisterFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: RegisterForm(),
          ),
        ),
      ),
    );
  }
}
