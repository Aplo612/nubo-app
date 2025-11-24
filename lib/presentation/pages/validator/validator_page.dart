import 'package:flutter/material.dart';
import 'package:nubo/config/constants/enviroments.dart';
import 'package:nubo/presentation/utils/navegation_router_utils/safe_navegation.dart';
import 'package:nubo/presentation/views/validator/ValidatorForm.dart';

class ValidatorPage extends StatelessWidget {
  static const String name = 'validator_page';
  const ValidatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => NavigationHelper.safePushReplacement(context, '/home'),
        ),
        title: const Text(
          'Validador',
          style: TextStyle(
            fontFamily: robotoBold,
            color: Colors.black87,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: background,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.0),
            child: ValidatorForm(),
          ),
        ),
      ),
    );
  }
}