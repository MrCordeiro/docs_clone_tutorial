import "package:docs_clone_tutorial/colors.dart";
import "package:docs_clone_tutorial/models/document.dart";
import "package:docs_clone_tutorial/models/error.dart";
import 'package:docs_clone_tutorial/services/auth_repository.dart';
import "package:docs_clone_tutorial/services/document.dart";
import "package:docs_clone_tutorial/widgets/loader.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:routemaster/routemaster.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signOut();
    // Clear data from provider
    ref.read(userProvider.notifier).update((state) => null);
  }

  void _createDocument(BuildContext context, WidgetRef ref) async {
    String token = ref.read(userProvider)!.token;
    final navigator = Routemaster.of(context);
    final snackbar = ScaffoldMessenger.of(context);

    // Create a new document
    final document =
        await ref.read(documentRepositoryProvider).createDocument(token);

    // If document isn't null, navigate to the document
    if (document.data != null) {
      navigator.push('/document/${document.data.id}');
    } else {
      // Show snackbar with error message
      snackbar.showSnackBar(SnackBar(content: Text(document.error!)));
    }
  }

  void navigateToDocument(BuildContext context, String id) {
    Routemaster.of(context).push('/document/$id');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () => _createDocument(context, ref),
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
        body: FutureBuilder<ErrorModel>(
          future: ref
              .watch(documentRepositoryProvider)
              .getDocuments(ref.watch(userProvider)!.token),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            return Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                width: 600,
                child: ListView.builder(
                  itemCount: snapshot.data!.data.length,
                  itemBuilder: ((context, index) {
                    DocumentModel document = snapshot.data!.data[index];
                    return InkWell(
                      onTap: () => navigateToDocument(context, document.id),
                      child: SizedBox(
                        height: 50,
                        child: Card(
                            child: Center(
                                child: Text(
                          document.title,
                          style: const TextStyle(fontSize: 17),
                        ))),
                      ),
                    );
                  }),
                ),
              ),
            );
          }),
        ));
  }
}
