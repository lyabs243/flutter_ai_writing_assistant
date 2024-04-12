import 'package:flutter/material.dart';

class LanguageSelectionWidget extends StatelessWidget {

  const LanguageSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      borderRadius: BorderRadius.circular(12),
      value: 'en',
      items: const [
        DropdownMenuItem(
          value: 'en',
          child: Text('🇺🇸 English'),
        ),
        DropdownMenuItem(
          value: 'fr',
          child: Text('🇫🇷 Français'),
        ),
        DropdownMenuItem(
          value: 'es',
          child: Text('🇪🇸 Español'),
        ),
        // swahili
        DropdownMenuItem(
          value: 'sw',
          child: Text('🇰🇪 Kiswahili'),
        ),
        // lingala
        DropdownMenuItem(
          value: 'ln',
          child: Text('🇨🇩 Lingala'),
        ),
        // Hindi
        DropdownMenuItem(
          value: 'hi',
          child: Text('🇮🇳 हिन्दी'),
        ),
        // arab
        DropdownMenuItem(
          value: 'ar',
          child: Text('🇸🇦 العربية'),
        ),
        // Chinese
        DropdownMenuItem(
          value: 'zh',
          child: Text('🇨🇳 中文'),
        ),
      ],
      onChanged: (value) {
      },
    );
  }

}