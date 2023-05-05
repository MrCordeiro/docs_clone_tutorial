import 'dart:async';

import 'package:docs_clone_tutorial/colors.dart';
import 'package:docs_clone_tutorial/models/document.dart';
import 'package:docs_clone_tutorial/models/error.dart';
import 'package:docs_clone_tutorial/services/auth_repository.dart';
import 'package:docs_clone_tutorial/services/document.dart';
import 'package:docs_clone_tutorial/services/socket.dart';
import 'package:docs_clone_tutorial/widgets/loader.dart';
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
  quill.QuillController? _controller = quill.QuillController.basic();
  ErrorModel? _document;
  final SocketServices _socketServices = SocketServices();

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
      // Update title and controller
      _titleController.text = (_document!.data! as DocumentModel).title;
      _controller = quill.QuillController(
          document: _document!.data.content.isEmpty
              ? quill.Document()
              : quill.Document.fromDelta(
                  quill.Delta.fromJson(_document!.data.content)),
          selection: const TextSelection.collapsed(offset: 0));
      setState(() {});
    }

    // Send local changes to server
    _controller!.document.changes.listen((event) {
      // event is an instance of DocChange
      if (event.source == quill.ChangeSource.LOCAL) {
        Map<String, dynamic> map = {
          'delta': event.change,
          'room': widget.id,
        };
        _socketServices.typing(map);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _socketServices.joinRoom(widget.id);
    fetchDocumentData();

    // Update document data when changes are received from server
    _socketServices.changeListener((data) => {
          _controller?.compose(
            quill.Delta.fromJson(data['delta']),
            _controller?.selection ?? const TextSelection.collapsed(offset: 0),
            quill.ChangeSource.REMOTE,
          )
        });

    // Autosave document every 2 seconds
    Timer.periodic(const Duration(seconds: 2), (timer) {
      _socketServices.autoSave(<String, dynamic>{
        'delta': _controller!.document.toDelta(),
        'room': widget.id,
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(body: Loader());
    }
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
                    controller: _controller!, multiRowsDisplay: false),
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
                        controller: _controller!,
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
