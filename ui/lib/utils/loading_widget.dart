import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({super.key, this.loadingMessage = ""});

  final String loadingMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 30,
        children: [
          CircularProgressIndicator(),
          if (loadingMessage.isNotEmpty) Text(loadingMessage),
        ],
      ),
    );
  }
}
