import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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