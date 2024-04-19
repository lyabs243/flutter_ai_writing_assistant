import 'package:flutter/material.dart';
import 'package:flutter_ai_writing_assistant/models/language_model.dart';

class LanguageSelectionWidget extends StatelessWidget {

  final LanguageModel selectedLanguage;
  final Function(LanguageModel?)? onLanguageSelected;

  const LanguageSelectionWidget({super.key, required this.selectedLanguage, this.onLanguageSelected});

  @override
  Widget build(BuildContext context) {

    return DropdownButton<LanguageModel>(
      borderRadius: BorderRadius.circular(12),
      value: selectedLanguage,
      items: LanguageModel.getSupportedLanguages().map((LanguageModel language) {
        return DropdownMenuItem<LanguageModel>(
          value: language,
          child: Text(language.name),
        );
      }).toList(),
      onChanged: onLanguageSelected,
    );
  }

}