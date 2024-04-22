// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:flutter_ai_writing_assistant/models/assistant_result_model.dart';
import 'package:flutter_ai_writing_assistant/models/edit_model.dart';
import 'package:flutter_ai_writing_assistant/utils/methods.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ai_writing_assistant/controllers/assistant_controller.dart';

void main() {
  group('AssistantController', () {
    test('Test check method', () async {
      final controller = AssistantController();
      const String sentence = String.fromEnvironment('SENTENCE');
      AssistantResultModel? result =  await controller.check(sentence);

      if (result != null) {
        print('=============> Result <=============\n');
        print("Input: $sentence\n");
        print("Correction: ${result.correction}\n");
        print("Suggestion: ${result.suggestion}\n");
        print("Correction Quill Delta: ${result.correctionQuillDelta}\n");
        
        print("==> Edits\n");
        for (EditModel edit in result.edits) {
          print("${edit.oldText} -> ${edit.newText} => ${edit.getReason('en')}\n");
        }

      }

      expect(result, isNotNull);
    });
  });

  group("Quill Delta", () {
    test('Test textToQuillDelta method', () {
      const String oldText = '''Je vais a la ecole pour lire leu livre''';
      const String text = '''Je vais à l'école pour lire les livres''';
      final List<EditModel> elements = [
        EditModel(oldText: "a", newText: "à", reasons: {}),
        EditModel(oldText: "leu", newText: "les", reasons: {}),
      ];
      List<Map<String, dynamic>> delta = textToQuillDelta(text, oldText, elements);

      print('=============> Quill Delta <=============\n');
      print("Input: $text\n");
      print("Elements: ${elements.map((e) => '${e.oldText} -> ${e.newText}')}\n");

      String encoded = jsonEncode(delta);
      print("Delta: $encoded\n");

      expect(delta, isNotEmpty);
    });
  });
}