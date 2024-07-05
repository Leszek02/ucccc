import 'package:flutter/material.dart';
import 'package:ucccc/data/template.dart';
import 'package:ucccc/ui/widgets/circle_button.dart';

class TemplateEditor extends StatefulWidget {
  const TemplateEditor({super.key});

  @override
  State<TemplateEditor> createState() => _TemplateEditorState();
}

class _TemplateEditorState extends State<TemplateEditor> {
  final Template _template = Template.empty();
  final List<String> _types = ['integer', 'text', 'logic', 'list', 'enum'];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.75),
          title: const Text('Template Editor'),
          actions: [IconButton(icon: const Icon(Icons.save), onPressed: () => print(_template))],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Table(
                  columnWidths: const {0: FlexColumnWidth(1), 1: IntrinsicColumnWidth()},
                  defaultVerticalAlignment: TableCellVerticalAlignment.top,
                  children: [
                    for (int i = 0; i < _template.template.length; ++i)
                      TableRow(
                        children: [
                          SizedBox(
                            height: 40,
                            child: TextFormField(
                              initialValue: _template.template[i].$1,
                              onChanged: (text) => setState(() => _template.template[i] = (text, _template.template[i].$2)),
                            ),
                          ),
                          DropdownButton(
                            value: _template.template[i].$2,
                            items: _types.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                            onChanged: (type) => setState(() => _template.template[i] = (_template.template[i].$1, type)),
                          )
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
                      onPressed: () => setState(() => _template.template.add(('', null))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
