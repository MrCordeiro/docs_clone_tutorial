import 'package:docs_clone_tutorial/models/error.dart';
import 'package:docs_clone_tutorial/repository/auth_repository.dart';
import 'package:docs_clone_tutorial/screens/home.dart';
import 'package:docs_clone_tutorial/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ErrorModel? errorModel;
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    // ref is a special variable provided by ConsumerState
    errorModel = await ref.read(authRepositoryProvider).getUserData();

    if (errorModel != null && errorModel!.data != null) {
      // Update the userProvider with the user data
      ref.read(userProvider.notifier).update((state) => errorModel!.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return MaterialApp(
      title: 'Docs Clone',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: user == null ? const LoginScreen(): const HomeScreen(),
    );
  }
}
