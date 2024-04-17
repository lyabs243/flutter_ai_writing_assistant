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

    return AssistantResultModel(
      sentenceLang: json[fieldSentenceLang]?? '',
      correction: json[fieldCorrection],
      suggestion: suggestion,
      edits: List<EditModel>.from(json[fieldEdits].map((e) => EditModel.fromJson(e))),
      correctionQuillDelta: List.from(json[fieldCorrectionQuillDelta]),
    );
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

}