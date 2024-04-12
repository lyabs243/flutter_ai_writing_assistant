import 'package:flutter/material.dart';
import 'package:flutter_ai_writing_assistant/utils/methods.dart';

class TextSuggestionWidget extends StatelessWidget {

  final String text;

  const TextSuggestionWidget({super.key, required this.text,});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/stars.png',
                    color: Colors.white,
                    width: 30,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Suggestion',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  copyText(context, text);
                },
                child: const Icon(
                  Icons.copy,
                  color: Colors.white,
                ),
              )
            ],
          ),
          Divider(color: Colors.white.withOpacity(0.2)),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

}