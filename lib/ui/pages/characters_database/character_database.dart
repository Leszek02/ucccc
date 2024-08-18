import 'package:flutter/material.dart';

class CharacterDatabasePage extends StatelessWidget {
  const CharacterDatabasePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.75),
          title: const Text('Character Editor'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('This is the characters_database page. Duh'),
            ],
          ),
        ),
      );
}
