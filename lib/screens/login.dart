import 'package:docs_clone_tutorial/colors.dart';
import 'package:docs_clone_tutorial/repository/auth_repository.dart';
import 'package:docs_clone_tutorial/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void _signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final sMessager = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final errorModel = await ref.read(authRepositoryProvider).signInWithGoogle();

    if (errorModel.error == null) {
      // Update the provider state with the user data
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      // Navigate to the home screen
      navigator.push(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      sMessager.showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => _signInWithGoogle(ref, context),
        icon: Image.asset('assets/images/g-logo.png', height: 20.0),
        label: const Text('Sign in with Google',
            style: TextStyle(color: kBlackColor)),
        style: ElevatedButton.styleFrom(
            backgroundColor: kWhiteColor, minimumSize: const Size(150, 50)),
      ),
    );
  }
}
