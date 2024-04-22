import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ai_writing_assistant/models/edit_model.dart';

copyText(BuildContext context, String text) {
  Clipboard.setData(ClipboardData(text: text));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: const Row(
        children: [
          Icon(Icons.check, color: Colors.white),
          SizedBox(width: 10),
          Text(
            'Text copied to clipboard',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}

/// Converts a given text into a Quill Delta format.
/// @param text The text to be converted into Quill Delta format.
/// @param elements The elements to be included in the delta with a link attribute.
/// @return A list of maps representing the Quill Delta format of the input text.
List<Map<String, dynamic>> textToQuillDelta(String text, String oldText, List<EditModel> elements) {
  List<Map<String, dynamic>> delta = [];

  int index = 0;
  for (EditModel element in elements) {
    try {
      Iterable<Match> matches = element.newText.allMatches(text);
      // in case of multiple matches, we the correct one is the one that the old text index difference is the smallest
      int minDifference = 1000 + element.newText.length;
      int startIndex = -1;
      int oldTextIndex = oldText.indexOf(element.oldText);
      for (Match match in matches) {
        int difference = (match.start - oldTextIndex).abs();
        if (difference < minDifference) {
          minDifference = difference;
          startIndex = match.start;
        }
      }

      if (startIndex != -1) {
        String beforeText = text.substring(index, startIndex);
        if (beforeText.isNotEmpty) {
          delta.add({"insert": beforeText});
        }
        delta.add({"insert": element.newText, "attributes": {"link": elements.indexOf(element).toString()}});
        index = startIndex + element.newText.length;
      }
    }
    catch (err) {
      debugPrint('===> Failed to find word: ${element.newText} - $err');
    }
  }

  String remainingText = text.substring(index);
  if (remainingText.isNotEmpty) {
    delta.add({"insert": remainingText});
  }

  // add a newline at the end as it is required
  delta.add({"insert": "\n"});

  return delta;
}

// List<Map<String, dynamic>> textToQuillDeltaOld(String text, List<String> elements) {
//   List<Map<String, dynamic>> delta = [];
//
//   int index = 0;
//   for (String element in elements) {
//     int startIndex = text.indexOf(element, index);
//     if (startIndex != -1) {
//       String beforeText = text.substring(index, startIndex);
//       if (beforeText.isNotEmpty) {
//         delta.add({"insert": beforeText});
//       }
//       delta.add({"insert": element, "attributes": {"link": elements.indexOf(element).toString()}});
//       index = startIndex + element.length;
//     }
//   }
//
//   String remainingText = text.substring(index);
//   if (remainingText.isNotEmpty) {
//     delta.add({"insert": remainingText});
//   }
//
//   // add a newline at the end as it is required
//   delta.add({"insert": "\n"});
//
//   return delta;
// }