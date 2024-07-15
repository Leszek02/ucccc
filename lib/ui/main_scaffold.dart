import 'package:flutter/material.dart';
import 'package:ucccc/ui/pages/character/character_editor.dart';
import 'package:ucccc/ui/pages/profile/profile_page.dart';
import 'package:ucccc/ui/pages/settings/settings_page.dart';
import 'package:ucccc/ui/pages/template/template_editor.dart';
import 'package:ucccc/ui/widgets/circle_button.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.75),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('U', style: TextStyle(fontSize: 48)),
              for (int i = 0; i < 4; ++i) Text('C', style: TextStyle(fontSize: 40 - 8.0 * i)),
            ],
          ),
        ),
        body: Container(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
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
                              icon: Icons.person,
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const ProfilePage()),
                              ),
                            ),
                            const SizedBox(height: 32),
                            CircleButton(
                              size: 64,
                              icon: Icons.settings,
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const SettingsPage()),
                              ),
                            ),
                          ],
                        ),
                        CircleButton(
                          size: 80,
                          icon: Icons.bookmark_add,
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const TemplateEditor(title: "New template", mainTemplate: true,)),
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
