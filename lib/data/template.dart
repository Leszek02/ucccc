class Template {
  final List<Map<String, String?>> objects;
  final List<(String, String?)> template;

  Template.empty()
      : objects = [],
        template = [];

  Map<String, dynamic> toMap() => {
        'objects': objects,
        'template': Map.fromEntries(template.map((entry) => MapEntry(entry.$1, entry.$2))),
      };

  @override
  String toString() => toMap().toString();
}
