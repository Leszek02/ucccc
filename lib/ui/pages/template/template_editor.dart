import 'package:flutter/material.dart';
import 'package:ucccc/data/template.dart';
import 'package:ucccc/ui/widgets/circle_button.dart';

class TemplateEditor extends StatefulWidget {
  final String title;
  final bool mainTemplate;

  const TemplateEditor(
      {super.key, required this.title, required this.mainTemplate});

  @override
  State<TemplateEditor> createState() => _TemplateEditorState();
}

class _TemplateEditorState extends State<TemplateEditor> {
  static Template _template = Template.empty();
  final List<String> _types = ['integer', 'text', 'logic', 'list', 'enum'];
  List<(String, String?)> curList = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    if (widget.mainTemplate) {
      curList = _template.template;
    } else {
      curList = [];
      if (!_template.objects.containsKey(widget.title)) {
        _template.objects[widget.title] = <String, String?>{};
      }
      _template.objects[widget.title]?.forEach((k, v) => curList.add((k, v)));
      print(curList);
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        if (!widget.mainTemplate) {
          Navigator.pop(context);
        } else {
          final bool shouldPop = await _showBackDialog() ?? false;
          if (context.mounted && shouldPop) {
            _template = Template.empty();
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
            if (widget.mainTemplate) NewObjectButton(),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () => print(_template),
            ),
          ],
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
                    for (int i = 0; i < curList.length; ++i)
                      TableRow(
                        children: [
                          SizedBox(
                            height: 40,
                            child: TextFormField(
                              initialValue: curList[i].$1,
                              onChanged: (text) {
                                setState(() {
                                  if (widget.mainTemplate) {
                                    _template.template[i] =
                                        (text, curList[i].$2);
                                  } else {
                                    _template.objects[widget.title]
                                        ?.remove(curList[i].$1);
                                    _template.objects[widget.title]?[text] =
                                        curList[i].$2;
                                  }
                                });
                              },
                            ),
                          ),
                          DropdownButton(
                              value: curList[i].$2,
                              items: _types
                                  .map((type) => DropdownMenuItem(
                                      value: type, child: Text(type)))
                                  .toList(),
                              onChanged: (type) {
                                setState(() {
                                  if (widget.mainTemplate) {
                                    _template.template[i] =
                                        (curList[i].$1, type);
                                  } else {
                                    _template.objects[widget.title]
                                        ?[curList[i].$1] = type;
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
                              _template.template.add(('', null));
                            } else {
                              _template.objects[widget.title]![''] = null;
                            }
                          });
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
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
}

class NewObjectButton extends StatelessWidget {
  NewObjectButton({super.key});

  final TextEditingController _objectName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () => _dialogBuilder(context),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
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
                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog');
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TemplateEditor(
                                title: _objectName.text,
                                mainTemplate: false,
                              ),
                            ));
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        });
  }
}
