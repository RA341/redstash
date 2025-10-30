import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    super.key,
    required this.title,
    required this.error,
    this.stacktrace = "",
  });

  final String title;
  final String error;
  final String stacktrace;

  @override
  Widget build(BuildContext context) {
    // todo
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Text(error),
        if (stacktrace.isNotEmpty) Text(stacktrace),
      ],
    );
  }
}

Future<void> showErrorDialog({
  required BuildContext context,
  required String title,
  required String error,
}) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: ErrorDisplay(title: title, error: error),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Close"),
        ),
      ],
    ),
  );
}
