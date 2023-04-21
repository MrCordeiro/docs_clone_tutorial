import 'package:docs_clone_tutorial/colors.dart';
import 'package:docs_clone_tutorial/services/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void _signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final sMessager = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);
    final errorModel =
        await ref.read(authRepositoryProvider).signInWithGoogle();

    if (errorModel.error == null) {
      // Update the provider state with the user data
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      // Navigate to the home screen
      navigator.replace("/");
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
    return Scaffold(
        body: Center(
      child: ElevatedButton.icon(
        onPressed: () => _signInWithGoogle(ref, context),
        icon: Image.asset('assets/images/g-logo.png', height: 20.0),
        label: const Text('Sign in with Google',
            style: TextStyle(color: blackColor)),
        style: ElevatedButton.styleFrom(
            backgroundColor: whiteColor, minimumSize: const Size(150, 50)),
      ),
    ));
  }
}
