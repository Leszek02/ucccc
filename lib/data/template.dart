class Template {
  String _name;
  List<(String, List<(String, String?)>)> objects;
  final List<(String, String?)> _template;

  Template.empty()
      : _name = 'default',
        objects = [],
        _template = [];

  List<(String, String?)> get template => _template;

  set name(String value) => _name = value;

  Map<String, dynamic> toMap() => {
        'objects': Map.fromEntries(
            objects.map((entry) => MapEntry(entry.$1, Map.fromEntries(entry.$2.map((e) => MapEntry(e.$1, e.$2)))))),
        'template': Map.fromEntries(_template.map((entry) => MapEntry(entry.$1, entry.$2))),
        'name': _name,
      };

  @override
  String toString() => toMap().toString();
}
