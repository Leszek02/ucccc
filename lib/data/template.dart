typedef FieldList = List<(String, String?)>;

class Template {
  String name;
  List<(String, FieldList)> objects;
  List<(String, List<String>)> enums;
  final FieldList _template;

  Template.empty()
      : name = 'default',
        objects = [],
        enums = [],
        _template = [];

  factory Template.fromMap(Map<String, dynamic> data) {
    if (data['template'] is Map) return Template._fromDatabaseMap(data);
    return Template._fromDefaultMap(data);
  }

  Template._fromDefaultMap(Map<String, dynamic> data)
      : name = data['name'] ?? 'default',
        objects = data['objects'] ?? [],
        enums = data['enums'] ?? [],
        _template = data['template'] ?? [];

  factory Template._fromDatabaseMap(Map<String, dynamic> data) {
    Template template = Template.empty();
    template.name = data['name'];
    for (var key in data['objects'].keys) {
      final List<(String, String?)> newObject = [];
      for (var subkey in data['objects'][key].keys) {
        newObject.add((subkey, data['objects'][key][subkey]));
      }
      template.objects.add((key, newObject));
    }
    for (var key in data['template'].keys) {
      template._template.add((key, data['template'][key]));
    }
    return template;
  }

  List<(String, String?)> get template => _template;

  Map<String, dynamic> toMap() => {
        'objects': Map.fromEntries(
            objects.map((entry) => MapEntry(entry.$1, Map.fromEntries(entry.$2.map((e) => MapEntry(e.$1, e.$2)))))),
        'enums': Map.fromEntries(enums.map((entry) => MapEntry(entry.$1, entry.$2))),
        'template': Map.fromEntries(_template.map((entry) => MapEntry(entry.$1, entry.$2))),
        'name': name,
      };

  @override
  String toString() => toMap().toString();
}
