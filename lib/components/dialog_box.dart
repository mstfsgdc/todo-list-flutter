import 'package:flutter/material.dart';

import 'custom_button.dart';

class DialogBox extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const DialogBox(
      {super.key,
      required this.controller,
      required this.onSave,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey[300],
      content: SizedBox(
        height: 120,
        child: Column(
          children: [
            // user input
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Add a new task",
              ),
            ),
            // buttons (save & close)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // save
                CustomButton(
                  text: "Save",
                  onPressed: onSave,
                ),
                // close
                CustomButton(text: "Close", onPressed: onCancel),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
