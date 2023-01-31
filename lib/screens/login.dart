import 'package:docs_clone_tutorial/colors.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Image.asset('assets/images/g-logo.png', height: 20.0),
        label: const Text('Sign in with Google',
            style: TextStyle(color: kBlackColor)),
        style: ElevatedButton.styleFrom(
            backgroundColor: kWhiteColor, minimumSize: const Size(150, 50)),
      ),
    );
  }
}
