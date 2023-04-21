import 'package:docs_clone_tutorial/colors.dart';
import 'package:docs_clone_tutorial/models/document.dart';
import 'package:docs_clone_tutorial/models/error.dart';
import 'package:docs_clone_tutorial/services/auth_repository.dart';
import 'package:docs_clone_tutorial/services/document.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;
  const DocumentScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  final TextEditingController _titleController =
      TextEditingController(text: "Untitled Document");
  final quill.QuillController _controller = quill.QuillController.basic();
  ErrorModel? _document;

  void updateTitle(WidgetRef ref, String title) {
    ref.read(documentRepositoryProvider).updateTitle(
          token: ref.read(userProvider)!.token,
          id: widget.id,
          title: title,
        );
  }

  void fetchDocumentData() async {
    String token = ref.read(userProvider)!.token;
    _document = await ref.read(documentRepositoryProvider).getDocument(
          token,
          widget.id,
        );

    if (_document!.data != null) {
      _titleController.text = (_document!.data! as DocumentModel).title;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDocumentData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 9),
            child: Row(
              children: [
                Image.asset('assets/images/docs-logo.png', height: 40),
                const SizedBox(width: 10),
                SizedBox(
                  width: 180,
                  child: TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: blueColor)),
                        contentPadding: EdgeInsets.only(left: 10),
                      ),
                      onSubmitted: (value) => updateTitle(ref, value)),
                )
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: grayColor, width: 0.1)),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.lock,
                  size: 16,
                ),
                label: const Text("Share"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                ),
              ),
            )
          ],
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: quill.QuillToolbar.basic(
                    controller: _controller, multiRowsDisplay: false),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SizedBox(
                  width: 750,
                  child: Card(
                    color: whiteColor,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: quill.QuillEditor.basic(
                        controller: _controller,
                        readOnly: false,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
