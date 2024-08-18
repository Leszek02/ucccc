import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucccc/ui/widgets/circle_button.dart';
import 'package:ucccc/util/utility.dart';

class CharactersDatabasePage extends StatefulWidget {
  const CharactersDatabasePage({super.key});

  @override
  State<CharactersDatabasePage> createState() => _CharactersDatabasePageState();
}

class _CharactersDatabasePageState extends State<CharactersDatabasePage> {
  String _displayedName = "default";

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.75),
          title: const Text('Templates'),
        ),
        body: Center(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('templates').snapshots(),
            builder: (context, snapshot) => !snapshot.hasData
                ? const Text('Loading...')
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => _TemplateView(
                      templateData: snapshot.data!.docs[index].data(),
                      document: snapshot.data!.docs[index].reference,
                    ),
                  ),
          ),
        ),
      );
}

class _TemplateView extends StatelessWidget {
  final DocumentReference document;
  final Map<String, dynamic> templateData;

  const _TemplateView({required this.templateData, required this.document});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Card(
          color: Colors.purple.shade100,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  templateData['name'] ?? '<default>',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // TODO Leszusiu odbierz prosze :((( (zrob edycje template)
              IconButton(onPressed: () => print('edit template'), icon: const Icon(Icons.edit)), // Navigator.push(...)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: document.delete,
              ),
            ],
          ),
        ),
      );
}
