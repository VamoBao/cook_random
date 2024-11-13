import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class XCFParser {
  parseResponse(Response res) {
    final document = parse(res.data);
    return _parseIngredients(document);
  }

  _parseIngredients(Document document) {
    final list = document.querySelector('.ings')?.getElementsByTagName('tr');
    return list?.map((o) {
      String name = o.querySelector('a')?.text ?? '';
      String unit = o.querySelector('.unit')?.text ?? '';
      return '$unit$name'.trim();
    }).toList();
  }
}
