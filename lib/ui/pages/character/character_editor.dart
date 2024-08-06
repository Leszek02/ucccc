import 'package:flutter/material.dart';
import 'package:ucccc/ui/widgets/circle_button.dart';

class CharacterEditor extends StatelessWidget {
  const CharacterEditor({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.75),
          title: const Text('Character Editor'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          ),
        ),
      );
}
