import 'package:cook_random/model/Menu.dart';
import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class XCFParser {
  parseResponse(Response res) {
    final document = parse(res.data);
    return (
      materials: _parseMaterials(document),
      steps: _parseSteps(document),
      title: _parseTitle(document),
      remark: _parseRemark(document),
    );
  }

  List<MenuMaterial>? _parseMaterials(Document document) {
    final list = document.querySelector('.ings')?.getElementsByTagName('tr');
    return list?.map((o) {
      String name = (o.querySelector('a')?.text.trim() ??
              o.querySelector('.name')?.text.trim()) ??
          '';
      String unit = (o.querySelector('.unit')?.text ?? '').trim();
      return MenuMaterial(name: name, unit: unit);
    }).toList();
  }

  List<String>? _parseSteps(Document document) {
    final list =
        document.querySelector('.steps')?.querySelectorAll('.container');
    return list?.map((o) {
      return o.querySelector('.text')?.text ?? ''.trim();
    }).toList();
  }

  String? _parseTitle(Document document) {
    return document.querySelector('.page-title')?.text.trim();
  }

  String? _parseRemark(Document document) {
    return document
            .querySelector('.tip-container')
            ?.querySelector('.tip')
            ?.text
            .trim() ??
        document.querySelector('.desc')?.text.trim();
  }
}
