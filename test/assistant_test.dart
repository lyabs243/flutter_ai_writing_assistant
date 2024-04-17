// ignore_for_file: avoid_print
import 'package:flutter_ai_writing_assistant/models/assistant_result_model.dart';
import 'package:flutter_ai_writing_assistant/models/edit_model.dart';
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
}