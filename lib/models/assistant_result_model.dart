import 'package:flutter_ai_writing_assistant/models/edit_model.dart';
import 'package:flutter_ai_writing_assistant/utils/methods.dart';

const fieldSentenceLang = 'sentence_lang';
const fieldCorrection = 'correction';
const fieldEdits = 'edits';
const fieldSuggestion = 'suggestion';

class AssistantResultModel {

  String sentenceLang, correction;
  String? suggestion;
  List<EditModel> edits;
  List correctionQuillDelta = [];

  AssistantResultModel({
    this.sentenceLang = '',
    required this.correction,
    this.suggestion,
    required this.edits,
  });

  // fromJson
  factory AssistantResultModel.fromJson(Map<String, dynamic> json, String originalSentence) {

    if (!json.containsKey(fieldCorrection) || !json.containsKey(fieldEdits)) {
      throw ArgumentError('AssistantResultModel.fromJson: missing required fields');
    }

    // ensure that suggestion is not null and it is different from correction
    String? suggestion;
    if (json.containsKey(fieldSuggestion) && json[fieldSuggestion] != json[fieldCorrection]) {
      suggestion = json[fieldSuggestion];
    }

    AssistantResultModel model = AssistantResultModel(
      sentenceLang: json[fieldSentenceLang]?? '',
      correction: json[fieldCorrection],
      suggestion: suggestion,
      edits: List<EditModel>.from(json[fieldEdits].map((e) => EditModel.fromJson(e))),
    );
    model.correctionQuillDelta = textToQuillDelta(model.correction, originalSentence, model.edits);

    return model;
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      if (sentenceLang.isNotEmpty) fieldSentenceLang: sentenceLang,
      fieldCorrection: correction,
      fieldSuggestion: suggestion,
      fieldEdits: edits.map((e) => e.toJson()).toList(),
    };
  }

  // get edit by index (String) if exists
  EditModel? getEdit(String index) {
    if (int.tryParse(index) != null) {
      int i = int.parse(index);
      if (i >= 0 && i < edits.length) {
        return edits[i];
      }
    }
    return null;
  }

  List<String> get wordsEdited {
    List<String> words = [];
    for (EditModel edit in edits) {
      words.add(edit.newText);
    }
    return words;
  }

}