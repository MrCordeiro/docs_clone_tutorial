import "package:docs_clone_tutorial/colors.dart";
import "package:docs_clone_tutorial/repository/auth_repository.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signOut();
    // Clear data from provider
    ref.read(userProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add, color: kBlackColor),
          ),
          IconButton(
            onPressed: () => _signOut(ref),
            icon: const Icon(Icons.logout, color: kRedColor),
          ),
        ],
        backgroundColor: kWhiteColor,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          ref.watch(userProvider)!.email
        )
      )
    );
  }
}
