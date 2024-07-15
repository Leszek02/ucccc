class Template {
  final Map<String, Map<String, String?>> objects;
  final List<(String, String?)> template;

  Template.empty()
      : objects = {},
        template = [];

  Map<String, dynamic> toMap() => {
        'objects': objects.entries.map((entry) => {'name': entry.key, "entries": entry.value}).toList(),
        'template': Map.fromEntries(template.map((entry) => MapEntry(entry.$1, entry.$2))),
      };

  @override
  String toString() => toMap().toString();
}
