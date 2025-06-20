import 'package:flutter/material.dart';

class MyCheckBox extends StatelessWidget {
  final ValueNotifier<bool> valueNotifier;
  final Future<void> Function(bool newValue) onChanged;

  const MyCheckBox({
    super.key,
    required this.valueNotifier,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: valueNotifier,
      builder: (context, value, _) {
        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () async {
            valueNotifier.value = !value;
            await onChanged(!value);
          },
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: value ? Colors.blue : Colors.grey.shade300,
                width: 2,
              ),
              color: value ? Colors.blue : Colors.transparent,
            ),
            child: value
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : null,
          ),
        );
      },
    );
  }
}
