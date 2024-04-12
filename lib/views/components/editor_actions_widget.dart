import 'package:flutter/material.dart';

class EditorActionWidget extends StatelessWidget {

  final Function()? onEdit, onCopy, onNewText;

  const EditorActionWidget({super.key, this.onEdit, this.onCopy, this.onNewText});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: onNewText,
          icon: const Icon(Icons.undo),
          label: const Text(
            'New Text',
          ),
        ),
        TextButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit),
          label: const Text(
            'Edit',
          ),
        ),
        TextButton.icon(
          onPressed: onCopy,
          icon: const Icon(Icons.copy),
          label: const Text(
            'Copy',
          ),
        ),
      ],
    );
  }

}