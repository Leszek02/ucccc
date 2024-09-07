typedef FieldList = List<(String, String?)>;

class Template {
  String _name;
  List<(String, FieldList)> objects;
  List<(String, List<String>)> enums;
  final FieldList _template;

  Template.empty()
      : _name = 'default',
        objects = [],
        enums = [],
        _template = [];

  Template.fromMap(Map<String, dynamic> data)
      : _name = data['name'] ?? 'default',
        objects = data['objects'] ?? [],
        enums = data['enums'] ?? [],
        _template = data['template'] ?? [];

  List<(String, String?)> get template => _template;

  set name(String value) => _name = value;

  // Ponieważ nie potrafiłem tego zrobić w konstruktorze (Typy się nie zgadzały) :c
  Template transformFromMap(Map<String, dynamic> data) {
    Template template = Template.empty();
    template._name = data['name'];
    for (var key in data['objects'].keys) {
      List<(String, String?)> newObject = List.empty(growable: true);
      print(data['objects'][key]);
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

  Map<String, dynamic> toMap() => {
        'objects': Map.fromEntries(
            objects.map((entry) => MapEntry(entry.$1, Map.fromEntries(entry.$2.map((e) => MapEntry(e.$1, e.$2)))))),
        'enums': Map.fromEntries(enums.map((entry) => MapEntry(entry.$1, entry.$2))),
        'template': Map.fromEntries(_template.map((entry) => MapEntry(entry.$1, entry.$2))),
        'name': _name,
      };

  @override
  String toString() => toMap().toString();
}
