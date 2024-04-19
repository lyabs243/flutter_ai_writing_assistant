import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_writing_assistant/controllers/assistant_controller.dart';
import 'package:flutter_ai_writing_assistant/models/assistant_result_model.dart';
import 'package:flutter_ai_writing_assistant/models/edit_model.dart';
import 'package:flutter_ai_writing_assistant/models/language_model.dart';
import 'package:flutter_ai_writing_assistant/utils/constants.dart';
import 'package:flutter_ai_writing_assistant/utils/methods.dart';
import 'package:flutter_ai_writing_assistant/views/components/correction_tooltip.dart';
import 'package:flutter_ai_writing_assistant/views/components/editor_actions_widget.dart';
import 'package:flutter_ai_writing_assistant/views/components/editor_widget.dart';
import 'package:flutter_ai_writing_assistant/views/components/language_selection_widget.dart';
import 'package:flutter_ai_writing_assistant/views/components/text_suggestion_widget.dart';
import 'package:flutter_quill/flutter_quill.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  HomePageState createState() {
    return HomePageState();
  }

}

class HomePageState extends State<HomePage> {

  final QuillController quillController = QuillController.basic();
  final AssistantController assistantController = AssistantController();
  AssistantResultModel? result;
  bool readOnly = false, loading = false;
  LanguageModel selectedLanguage = LanguageModel.getSupportedLanguages().first;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        actions: [
          LanguageSelectionWidget(
            selectedLanguage: selectedLanguage,
            onLanguageSelected: (LanguageModel? language) {
              if (language != null) {
                setState(() {
                  selectedLanguage = language;
                });
              }
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.clear,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Writing Assistant',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              'Explanation will be in ${selectedLanguage.name}, you can change the language in the top right corner.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: EditorWidget(
                quillController: quillController,
                readOnly: readOnly,
                onChange: () {
                  setState(() {});
                },
                customRecognizerBuilder: (attribute, leaf) {
                  return TapGestureRecognizer()
                    ..onTapDown = (TapDownDetails details) {
                      showToolTip(details, attribute);
                    };
                },
              ),
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: readOnly,
              child: EditorActionWidget(
                onCopy: () {
                  copyText(context, quillController.document.toPlainText());
                },
                onEdit: () {
                  quillController.document = Document() .. insert(0, quillController.document.toPlainText());
                  setState(() {
                    readOnly = false;
                  });
                },
                onNewText: () {
                  quillController.document = Document();
                  setState(() {
                    readOnly = false;
                  });
                },
              ),
            ),
            Visibility(
              visible: !readOnly,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: Transform.scale(
                      scale: 0.5,
                      child: CircularProgressIndicator(
                        value: quillController.document.length / maxTextLength,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton.icon(
                    onPressed: (loading)? null:
                    () {
                      check(context);
                    },
                    icon: const Icon(Icons.check_circle_outline),
                    label: Text(
                      (loading)?
                      'Checking...':
                      'Check',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: readOnly && result?.suggestion != null,
              child: TextSuggestionWidget(
                text: result?.suggestion?? '',
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  check(BuildContext context) async {
    setState(() {
      loading = true;
    });

    // it is better to catch the error
    // the model may return malformed JSON data
    try {
      result = await assistantController.check(quillController.document.toPlainText());
      quillController.document = Document.fromJson(result!.correctionQuillDelta);

      setState(() {
        loading = false;
        readOnly = true;
      });
    }
    catch (e) {
      debugPrint('===> Error checking text: $e - ${result?.correctionQuillDelta}');

      setState(() {
        loading = false;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong, please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

  }

  showToolTip(TapDownDetails details, Attribute attribute) {
    // if it is link, show the tooltip
    if (attribute.key == 'link' && result != null) {
      final EditModel? edit = result!.getEdit(attribute.value
          .toString());
      if (edit != null) {
        CorrectionTooltip.show(
          context: context,
          tapDownDetails: details,
          oldText: edit.oldText,
          newText: edit.newText,
          explanation: edit.getReason(selectedLanguage.code),
        );
      }
    }
  }

}