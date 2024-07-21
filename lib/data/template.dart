class Template {
  final List<(String, List<(String, String?)>)> objects;
  final List<(String, String?)> template;

  Template.empty()
      : objects = [],
        template = [];

  Map<String, dynamic> toMap() => {
        'objects': Map.fromEntries(objects.map((entry) =>
            MapEntry(entry.$1, Map.fromEntries(entry.$2.map((e) =>
                MapEntry(e.$1, e.$2)))))),
        'template': Map.fromEntries(template.map((entry) => MapEntry(entry.$1, entry.$2))),
      };

  @override
  String toString() => toMap().toString();
}
