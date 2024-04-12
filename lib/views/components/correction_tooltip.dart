import 'package:flutter/material.dart';
import 'package:flutter_ai_writing_assistant/utils/constants.dart';

class CorrectionTooltip {

  static show({required BuildContext context, required TapDownDetails tapDownDetails, String oldText = '',
    String newText = '', String explanation = ''}) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        tapDownDetails.globalPosition.dx, // x position
        tapDownDetails.globalPosition.dy, // y position
        tapDownDetails.globalPosition.dx,
        0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      items: [
        PopupMenuItem(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  Text(
                    oldText,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_forward),
                  ),
                  Text(
                    newText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: correctionTextColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                explanation,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

}