import 'package:docs_clone_tutorial/colors.dart';
import 'package:docs_clone_tutorial/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void _signInWithGoogle(WidgetRef ref) {
    ref.watch(authRepositoryProvider).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => _signInWithGoogle(ref),
        icon: Image.asset('assets/images/g-logo.png', height: 20.0),
        label: const Text('Sign in with Google',
            style: TextStyle(color: kBlackColor)),
        style: ElevatedButton.styleFrom(
            backgroundColor: kWhiteColor, minimumSize: const Size(150, 50)),
      ),
    );
  }
}
