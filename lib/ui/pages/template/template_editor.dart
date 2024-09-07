import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ucccc/data/template.dart';
import 'package:ucccc/ui/widgets/circle_button.dart';

// TODO: Enum editor, print enum in drawer, emlum picker, check template name

class TemplateEditor extends StatefulWidget {
  final String title;
  final bool mainTemplate;
  final void Function((String, List<(String, String?)>))? exitCallback;

  //final List<(String, List<(String, String?)>)>? objectList;
  final Template? template;

  const TemplateEditor(
      {super.key,
      required this.title,
      required this.mainTemplate,
      this.exitCallback,
      this.template});

  @override
  State<TemplateEditor> createState() => TemplateEditorState();
}

class TemplateEditorState extends State<TemplateEditor> {
  Template template = Template.empty();
  final List<String> _types = ['integer', 'text', 'logic', 'list', 'enum'];
  List<(String, String?)> currentList = List.empty(growable: true);
  final TextEditingController _objectName = TextEditingController(),
      _templateName = TextEditingController();

  int index = 0;

  Future<void> _editObjectEnumDialog(BuildContext context, Template template,
      String title, String curName, bool object) {
    _objectName.text = curName;
    final formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Center(child: Text(title)),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: _objectName,
            decoration: const InputDecoration(
              hintText: 'Please write a username',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an object name'; // Inline validation message
              }
              for (var type in _types) {
                if (type == value) {
                  return 'This object already exists';
                }
              }
              return null;
            },
          ),
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
                child: Text('Rename'),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      int index = 0;
                      for (int i = 0; i < template.objects.length; ++i) {
                        if (template.objects[i].$1 == curName) {
                          index = i;
                        }
                        for (int j = 0;
                            j < template.objects[i].$2.length;
                            ++j) {
                          if (template.objects[i].$2[j].$2 == curName) {
                            template.objects[i].$2[j] = (
                              template.objects[i].$2[j].$1,
                              _objectName.text
                            );
                          }
                        }
                      }
                      for (int i = 0; i < template.template.length; ++i) {
                        if (template.template[i].$2 == curName) {
                          template.template[i] =
                              (template.template[i].$1, _objectName.text);
                        }
                      }
                      template.objects
                          .add((_objectName.text, template.objects[index].$2));
                      template.objects.removeAt(index);
                      for (int i = 0; i < _types.length; ++i) {
                        if (_types[i] == curName) {
                          index = i;
                          break;
                        }
                      }
                      _types.add(_objectName.text);
                      _types.removeAt(index);
                    });
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _newObjectEnumDialog(
      BuildContext context, Template template, String title) {
    _objectName.text = "";
    final formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Center(child: Text(title)),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: _objectName,
            decoration: const InputDecoration(
              hintText: 'Please write a username',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an object name'; // Inline validation message
              }
              for (var type in _types) {
                if (type == value) {
                  return 'This object already exists';
                }
              }
              return null;
            },
          ),
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
                child: Text('Create'),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    setState(() => template.objects
                        .add((_objectName.text, List.empty(growable: true))));
                    _types.add(_objectName.text);
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TemplateEditor(
                            title: _objectName.text,
                            mainTemplate: false,
                            exitCallback: exitCallback,
                            template: template),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool?> _showWarningDialog({
    required String title,
    required String content,
    required String cancel,
    required String confirm,
  }) =>
      showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge),
                child: Text(cancel),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge),
                child: Text(confirm),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          );
        },
      );

  void exitCallback((String, List<(String, String?)>) objectEntry) {
    int index =
        template.objects.indexWhere((element) => element.$1 == objectEntry.$1);
    template.objects[index] = objectEntry;
  }

  @override
  initState() {
    super.initState();
    if (widget.template != null) {
      template = widget.template!;
      template.objects = widget.template!.objects;
      for (int i = 0; i < template.objects.length; ++i) {
        _types.add(template.objects[i].$1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mainTemplate) {
      currentList = template.template;
    } else {
      index =
          template.objects.indexWhere((element) => element.$1 == widget.title);
      currentList = template.objects[index].$2;
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        if (!widget.mainTemplate) {
          Navigator.pop(context);
          widget.exitCallback?.call((widget.title, currentList));
        } else {
          final bool shouldPop = (await _showWarningDialog(
                title: 'Exiting template creator',
                content:
                    'Are you sure you want to leave this page? Unsaved changes will be discarded.',
                cancel: 'Stay',
                confirm: 'Leave',
              )) ??
              false;
          if (context.mounted && shouldPop) Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.75),
          title: Text(widget.title),
          actions: [
            if (widget.mainTemplate)
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Center(child: Text('Template name')),
                      content: TextField(controller: _templateName),
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
                              child: const Text('Save'),
                              onPressed: () {
                                template.name = _templateName.text;
                                FirebaseFirestore.instance
                                    .collection('templates')
                                    .add(template.toMap());
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
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
        endDrawer: widget.mainTemplate
            ? Drawer(
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      child: DrawerHeader(
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.75)),
                        child: const Center(child: Text('Objects & Enums')),
                      ),
                    ),
                    Text("Your Objects"),
                    Divider(color: Colors.black),
                    for (int i = 0; i < template.objects.length; ++i)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Text(template.objects[i].$1),
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => TemplateEditor(
                                      title: template.objects[i].$1,
                                      mainTemplate: false,
                                      exitCallback: exitCallback,
                                      template: template,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_note),
                              onPressed: () => _editObjectEnumDialog(
                                  context,
                                  template,
                                  'Rename Object',
                                  template.objects[i].$1,
                                  true),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final bool shouldDelete =
                                    await _showWarningDialog(
                                          title: 'Deleting object',
                                          content:
                                              'Are you sure you want to delete this object?',
                                          cancel: 'No',
                                          confirm: 'Yes',
                                        ) ??
                                        false;
                                if (shouldDelete) {
                                  for (int j = 0;
                                      j < template.objects.length;
                                      ++j) {
                                    template.objects[j].$2.removeWhere(
                                        (element) =>
                                            element.$2 ==
                                            template.objects[i].$1);
                                  }
                                  template.template.removeWhere((element) =>
                                      element.$2 == template.objects[i].$1);
                                  _types.remove(template.objects[i].$1);
                                  setState(() {
                                    template.objects.removeWhere((element) =>
                                        element.$1 == template.objects[i].$1);
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    Divider(color: Colors.black),
                    Text('Your Enums'),
                    Divider(color: Colors.black),
                    if (widget.mainTemplate)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => _newObjectEnumDialog(
                                      context, template, 'New Object name'),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.category),
                                    onPressed: () => _newObjectEnumDialog(
                                        context, template, 'New Enum name'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              )
            : null,
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
                              items: _types
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
}
