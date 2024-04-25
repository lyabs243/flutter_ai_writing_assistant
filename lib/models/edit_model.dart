const fieldEditOld = 'old';
const fieldEditNew = 'new';
const fieldEditReasons = 'reasons';

class EditModel {

  String oldText, newText;
  Map<String, String> reasons;

  EditModel({
    required this.oldText,
    required this.newText,
    required this.reasons,
  });

  // fromJson
  factory EditModel.fromJson(Map<String, dynamic> json) {

    if (!json.containsKey(fieldEditOld) || !json.containsKey(fieldEditNew) || !json.containsKey(fieldEditReasons)) {
      throw ArgumentError('EditModel.fromJson: missing required fields - $json');
    }

    return EditModel(
      oldText: json[fieldEditOld],
      newText: json[fieldEditNew],
      reasons: Map<String, String>.from(json[fieldEditReasons]),
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      fieldEditOld: oldText,
      fieldEditNew: newText,
      fieldEditReasons: reasons,
    };
  }

  // get reason from language code
  String getReason(String languageCode) {
    return reasons[languageCode] ?? '';
  }

}