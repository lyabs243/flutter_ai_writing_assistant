import 'package:flutter_ai_writing_assistant/models/edit_model.dart';

const fieldSentenceLang = 'sentence_lang';
const fieldCorrection = 'correction';
const fieldEdits = 'edits';
const fieldCorrectionQuillDelta = 'correction_quill';
const fieldSuggestion = 'suggestion';

class AssistantResultModel {

  String sentenceLang, correction;
  String? suggestion;
  List<EditModel> edits;
  List correctionQuillDelta;

  AssistantResultModel({
    this.sentenceLang = '',
    required this.correction,
    this.suggestion,
    required this.edits,
    required this.correctionQuillDelta,
  });

  // fromJson
  factory AssistantResultModel.fromJson(Map<String, dynamic> json) {

    if (!json.containsKey(fieldCorrection) || !json.containsKey(fieldEdits) || !json.containsKey(fieldCorrectionQuillDelta)) {
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
      correctionQuillDelta: List.from(json[fieldCorrectionQuillDelta]),
    );

    // ensure that the last quilt delta is a newline
    if (model.correctionQuillDelta.isNotEmpty) {
      final last = model.correctionQuillDelta.last;
      if (last['insert'] != '\n') {
        model.correctionQuillDelta.add({'insert': '\n'});
      }
    }

    return model;
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      if (sentenceLang.isNotEmpty) fieldSentenceLang: sentenceLang,
      fieldCorrection: correction,
      fieldSuggestion: suggestion,
      fieldEdits: edits.map((e) => e.toJson()).toList(),
      fieldCorrectionQuillDelta: correctionQuillDelta,
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

}