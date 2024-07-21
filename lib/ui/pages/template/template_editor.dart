import 'package:flutter/material.dart';
import 'package:ucccc/data/template.dart';
import 'package:ucccc/ui/widgets/circle_button.dart';

class TemplateEditor extends StatefulWidget {
  final String title;
  final bool mainTemplate;
  void Function((String, List<(String, String?)>))? exitCallback;

  TemplateEditor(
      {super.key,
      required this.title,
      required this.mainTemplate,
      this.exitCallback});

  @override
  State<TemplateEditor> createState() => TemplateEditorState();
}

class TemplateEditorState extends State<TemplateEditor> {
  Template template = Template.empty();
  List<String> types = ['integer', 'text', 'logic', 'list', 'enum'];
  List<(String, String?)> currentList = List.empty(growable: true);
  final TextEditingController _objectName = TextEditingController();
  int index = 0;

  Future<void> _dialogBuilder(BuildContext context, Template template) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlertDialog(
              title: const Center(child: Text('New object name')),
              content: TextField(
                controller: _objectName,
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog'),
                    ),
                    TextButton(
                      child: const Text('Create'),
                      onPressed: () {
                        if (_objectName.text.isEmpty) {
                          print(
                              "There's no object name"); //TODO: Toast a message or change whole thing to form
                        } else {
                          template.objects.add((_objectName.text, List.empty()));
                          Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TemplateEditor(
                                  title: _objectName.text,
                                  mainTemplate: false,
                                  exitCallback: exitCallback,
                                ),
                              ),
                            );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void exitCallback((String, List<(String, String?)>) objectEntry) {
    int index =
        template.objects.indexWhere((element) => element.$1 == objectEntry.$1);
      template.objects[index] = objectEntry;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mainTemplate) {
      currentList = template.template;
    } else {
      currentList = [];
      if (!template.objects.any((element) => element.$1 == widget.title)) {
        template.objects.add((widget.title, List.empty(growable: true)));
      }
      index =
          template.objects.indexWhere((element) => element.$1 == widget.title);
      currentList = template.objects[index].$2;
      print(currentList);
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        if (!widget.mainTemplate) {
          Navigator.pop(context);
          widget.exitCallback?.call((widget.title, currentList));
          print(template);
        } else {
          final bool shouldPop = await _showBackDialog() ?? false;
          if (context.mounted && shouldPop) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.75),
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () => print(template),
            ),
            if (widget.mainTemplate)
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _dialogBuilder(context, template),
              ),
            if (widget.mainTemplate)
              Builder(builder: (context) {
                return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    });
              })
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.75),
                ),
                child: Text('Drawer Header'),
              ),
              // for (int i = 0; i < template.objects.length; ++i)
              //   Row(
              //     children: [
              //       ListTile(
              //         title: Text(template.objects[i].$1),
              //         onTap: () {},
              //       ),
              //     ],
              //   ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: IntrinsicColumnWidth()
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.top,
                  children: [
                    for (int i = 0; i < currentList.length; ++i)
                      TableRow(
                        children: [
                          SizedBox(
                            height: 40,
                            child: TextFormField(
                              initialValue: currentList[i].$1,
                              onChanged: (text) {
                                setState(() {
                                  if (widget.mainTemplate) {
                                    template.template[i] =
                                        (text, currentList[i].$2);
                                  } else {
                                    template.objects[index].$2[i] =
                                        (text, currentList[i].$2);
                                  }
                                });
                              },
                            ),
                          ),
                          DropdownButton(
                              value: currentList[i].$2,
                              items: types
                                  .where((t) => t != widget.title)
                                  .map((type) => DropdownMenuItem(
                                      value: type, child: Text(type)))
                                  .toList(),
                              onChanged: (type) {
                                setState(() {
                                  if (widget.mainTemplate) {
                                    template.template[i] =
                                        (currentList[i].$1, type);
                                  } else {
                                    template.objects[index].$2[i] =
                                        (currentList[i].$1, type);
                                  }
                                });
                              })
                        ],
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 32),
                  child: Align(
                    alignment: Alignment.center,
                    child: CircleButton(
                      size: 64,
                      icon: Icons.add,
                      onPressed: () {
                        setState(() {
                          if (widget.mainTemplate) {
                            template.template.add(('', null));
                          } else {
                            template.objects[index].$2.add(('', null));
                          }
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showBackDialog() => showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Exiting template creator'),
            content: const Text(
              'Are you sure you want to leave this page? Unsaved changes will be discarded.',
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Stay'),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Leave'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        },
      );
}

// class NewObjectButton extends StatelessWidget {
//   NewObjectButton(this.template, {super.key});
//
//   Template template;
//   final TextEditingController _objectName = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.add),
//       onPressed: () => _dialogBuilder(context, template),
//     );
//   }
//
//   void exitCallback((String, List<(String, String?)>) objectEntry) {
//     int index =
//         template.objects.indexWhere((element) => element.$1 == objectEntry.$1);
//     template.objects[index] = objectEntry;
//   }
//
//   Future<void> _dialogBuilder(BuildContext context, Template template) {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AlertDialog(
//               title: const Center(child: Text('New object name')),
//               content: TextField(
//                 controller: _objectName,
//               ),
//               actions: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     TextButton(
//                       child: const Text('Cancel'),
//                       onPressed: () =>
//                           Navigator.of(context, rootNavigator: true)
//                               .pop('dialog'),
//                     ),
//                     TextButton(
//                       child: const Text('Create'),
//                       onPressed: () {
//                         if (_objectName.text.isEmpty) {
//                           print(
//                               "There's no object name"); //TODO: Toast a message or change whole thing to form
//                         } else {
//                           Navigator.of(context, rootNavigator: true)
//                               .pop('dialog');
//                           Navigator.of(context).push(MaterialPageRoute(
//                             builder: (context) => TemplateEditor(
//                               title: _objectName.text,
//                               mainTemplate: false,
//                               exitCallback: exitCallback,
//                             ),
//                           ));
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
