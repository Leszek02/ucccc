import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_share/social_share.dart';
import 'package:ucccc/data/template.dart';
import 'package:ucccc/ui/pages/template/template_editor.dart';
import 'package:ucccc/util/pastebin_communication.dart';

class CharactersDatabasePage extends StatefulWidget {
  const CharactersDatabasePage({super.key});

  @override
  State<CharactersDatabasePage> createState() => _CharactersDatabasePageState();
}

class _CharactersDatabasePageState extends State<CharactersDatabasePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.75),
          title: const Text('Templates'),
          actions: [
            IconButton(
              icon: const Icon(Icons.download_rounded),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => _ImportForm(
                  onConfirm: (code) async => download(code).then(
                    (template) => FirebaseFirestore.instance
                        .collection('templates')
                        .add(template.toMap()),
                    onError: (error) => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Error'),
                        content: Form(child: Text(error.toString())),
                        actions: [
                          TextButton(
                              child: const Text('OK'),
                              onPressed: () => Navigator.of(context).pop())
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('templates').snapshots(),
            builder: (context, snapshot) => !snapshot.hasData
                ? const Text('Loading...')
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => _TemplateView(
                      template:
                          Template.fromMap(snapshot.data!.docs[index].data()),
                      document: snapshot.data!.docs[index].reference,
                    ),
                  ),
          ),
        ),
      );
}

class _ImportForm extends StatefulWidget {
  final void Function(String) onConfirm;

  const _ImportForm({required this.onConfirm});

  @override
  State<_ImportForm> createState() => _ImportFormState();
}

class _ImportFormState extends State<_ImportForm> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Paste the code here'),
        content: TextField(controller: _controller),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onConfirm(_controller.text);
            },
            child: const Text('OK'),
          )
        ],
      );
}

class _TemplateView extends StatelessWidget {
  final DocumentReference document;
  final Template template;

  const _TemplateView({required this.template, required this.document});

  Future<void> _editTemplateName(
      BuildContext context, Template template, String documentId) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    controller.text = template.name;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Center(child: const Text("Rename object")),
        content: Form(
          key: formKey,
          child: TextField(controller: controller),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop('dialog'),
              ),
              TextButton(
                child: const Text('Rename'),
                onPressed: () {
                  template.name = controller.text;
                  FirebaseFirestore.instance
                      .collection('templates')
                      .doc(
                          documentId) // Specify the document ID you want to update
                      .update(template
                          .toMap()); // Update the document with new data
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Card(
            color: Colors.purple.shade100,
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TemplateEditor(
                    title: template.name,
                    mainTemplate: true,
                    template: template,
                    documentId: document.id,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      template.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () => upload(template).then(
                      (code) => SocialShare.shareOptions(
                          'Here\'s the code for my UCCCC template "${template.name}". '
                          'Paste it in the "import shared template" window in the Templates menu. '
                          'This code is valid for 10 minutes. $code'),
                      onError: (error) => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content: Form(child: Text(error.toString())),
                          actions: [
                            TextButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.of(context).pop())
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () =>
                          _editTemplateName(context, template, document.id),
                      icon: const Icon(Icons.edit)), // Navigator.push(...)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: document.delete,
                  ),
                ],
              ),
            )),
      );
}
