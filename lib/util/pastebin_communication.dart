import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ucccc/data/template.dart';

String PASTEBIN_API_KEY = 'ikqNfOFjyumpbhCzquYbp4zEdq4zeF7l';

Future<String> upload(Template template) async {
  var response = await http.post(Uri.https('pastebin.com', 'api/api_post.php'), body: {
    'api_dev_key': PASTEBIN_API_KEY,
    'api_option': 'paste',
    'api_paste_code': jsonEncode(template.toMap()),
    'api_paste_expire_date': '10M',
    'api_paste_format': 'json'
  });
  if (response.statusCode != 200) {
    return Future.error('Pastebin API responded with error: ${response.body} (status code ${response.statusCode}) ');
  }
  return response.body.split('/').last;
}

Future<Template> download(String code) async {
  var templateJson = await http.read(Uri.https('pastebin.com', 'raw/$code'));
  return Template.fromMap(jsonDecode(templateJson));
}