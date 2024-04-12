import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_writing_assistant/utils/constants.dart';
import 'package:flutter_quill/flutter_quill.dart';

class EditorWidget extends StatelessWidget {

  final bool readOnly;
  final QuillController quillController;
  final GestureRecognizer? Function(Attribute attribute, Leaf leaf) customRecognizerBuilder;
  final Function()? onChange;

  EditorWidget({super.key, required this.quillController, this.readOnly = false,
    required this.customRecognizerBuilder, this.onChange}) {
    quillController.document.changes.listen(_onDocumentChange);
  }

  @override
  Widget build(BuildContext context) {
    return QuillEditor.basic(
      configurations: QuillEditorConfigurations(
        controller: quillController,
        customStyles: const DefaultStyles(
          link: TextStyle(
            color: correctionTextColor,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            decorationStyle: TextDecorationStyle.dashed,
            decorationColor: Colors.grey,
            decorationThickness: 2.5,
          ),
        ),
        readOnly: readOnly,
        customRecognizerBuilder: customRecognizerBuilder,
      ),
    );
  }

  void _onDocumentChange(DocChange docChange) {

    if (readOnly) {
      return;
    }

    final documentLength = quillController.document.length;
    if (documentLength > maxTextLength) {
      const latestIndex = maxTextLength - 1;
      quillController.replaceText(
        latestIndex,
        documentLength - maxTextLength,
        '',
        const TextSelection.collapsed(offset: latestIndex),
      );
    }
    else {
      onChange?.call();
    }
  }

}