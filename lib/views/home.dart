import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
  bool readOnly = false, loading = false;

  @override
  void initState() {
    super.initState();
    quillController.document.insert(0, '''C est une joie immensee de savoir que mon artile de blog où j'ai écrit il y a deux semaines a ete mis en avant par Hashnode''');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        actions: [
          const LanguageSelectionWidget(),
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
              'Explanation will be in English, you can change the language in the top right corner.',
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
                      CorrectionTooltip.show(
                        context: context,
                        tapDownDetails: details,
                        oldText: 'Old Text',
                        newText: 'New Text',
                        explanation: 'The reason for the change, it could be a spelling mistake, a grammatical error, or a suggestion.',
                      );
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
                  quillController.document = Document() .. insert(0, '''C'est une joie immenses de savoir que mon article de blog où j'ai écrit il y a deux semaines a ete mis en avant par Hashnode''');
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
                     () async {
                      setState(() {
                        loading = true;
                      });
                      await Future.delayed(const Duration(seconds: 2));
                      quillController.document = Document.fromJson(jsonDecode('''[{"insert":"C'est","attributes":{"link":"0"}},{"insert":" une joie "},{"insert":"immenses","attributes":{"link":"1"}},{"insert":" de savoir que mon "},{"insert":"article","attributes":{"link":"2"}},{"insert":" de blog où j'ai écrit il y a deux semaines a ete mis en avant par Hashnode\\n"}]'''));
                      setState(() {
                        loading = false;
                        readOnly = true;
                      });
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
              visible: readOnly,
              child: const TextSuggestionWidget(
                text: '''Je suis extrêmement heureux d'apprendre que mon article de blog, que j'ai rédigé il y a deux semaines, a été mis en évidence par Hashnode.''',
              ),
            ),
          ],
        ),
      ),
    );
  }

}