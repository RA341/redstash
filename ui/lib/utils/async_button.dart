import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AsyncButton extends HookWidget {
  const AsyncButton({
    required this.onPress,
    required this.normalButton,
    required this.loadingButton,
    this.icon,
    super.key,
  });

  final Widget? icon;
  final Widget normalButton;
  final Future<void> Function() onPress;
  final Widget loadingButton;

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);

    return ElevatedButton.icon(
      label: isLoading.value ? loadingButton : normalButton,
      icon: icon,
      onPressed: isLoading.value
          ? null
          : () async {
              isLoading.value = true;
              await onPress();
              isLoading.value = false;
            },
    );
  }
}
