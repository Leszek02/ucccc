import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ucccc/ui/pages/character/character_editor.dart';
import 'package:ucccc/ui/pages/characters_database/character_database.dart';
import 'package:ucccc/ui/pages/templates_databse/templates_database.dart';
import 'package:ucccc/ui/pages/template/template_editor.dart';
import 'package:ucccc/ui/widgets/circle_button.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.75),
          title: const SizedBox(height: 32, child: Image(image: AssetImage("assets/logo.png"))),
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/SZAPKI_ENLIGHTENED.png"),
            fit: BoxFit.cover,
          )),
          //color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) => SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleButton(
                          size: 80,
                          icon: Icons.person_add,
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const CharacterEditor()),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleButton(
                              size: 64,
                              icon: Icons.people,
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const CharacterDatabasePage()),
                              ),
                            ),
                            //const SizedBox(height: 32),
                            CircleButton(
                              size: 32,
                              icon: Icons.cookie_outlined,
                              onPressed: () async {
                                final templates = FirebaseFirestore.instance.collection('templates');
                                // final query = templates.count();
                                // final AggregateQuerySnapshot result = await query.get();
                                // print(result.count);
                                final result = await templates.get();
                                for (final template in result.docs) {
                                  print(template.data());
                                }
                              },
                            ),
                            CircleButton(
                              size: 64,
                              icon: Icons.bookmarks,
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const CharactersDatabasePage()),
                              ),
                            ),
                          ],
                        ),
                        CircleButton(
                          size: 80,
                          icon: Icons.bookmark_add,
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const TemplateEditor(
                                title: "New template",
                                mainTemplate: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
