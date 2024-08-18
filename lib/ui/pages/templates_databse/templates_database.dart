import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ucccc/ui/widgets/circle_button.dart';
import 'package:ucccc/util/utility.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _displayedName = "default";

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.75),
          title: const Text('Settings'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleButton(
                      size: 65,
                      icon: Icons.lock_open,
                      onPressed: noop,
                    ),
                    CircleButton(
                      size: 65,
                      icon: Icons.login_outlined,
                      onPressed: noop,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextField(
                      obscureText: false,
                      onChanged: (newName) => _displayedName = newName,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter new name",
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () => setState(noop),
                      child: const Icon(Icons.check),
                    ),
                    Text(
                      _displayedName,
                      style: const TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 28,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
}

// class NameChanger extends StatefulWidget {
//   const NameChanger({super.key});
//
//   @override
//   State<NameChanger> createState() => _NameChangerState();
// }
//
// class _NameChangerState extends State<NameChanger> {
//   String displayedName = "default";
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
