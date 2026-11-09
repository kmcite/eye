import 'package:flutter/material.dart';

import 'package:eye/ui/glass.dart';
import 'package:eye/ui/theme.dart';

class EyeSwitch extends StatelessWidget {
  const EyeSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
    );
  }
}

class EyeSegmentedControl<T extends Object> extends StatelessWidget {
  const EyeSegmentedControl({
    super.key,
    required this.value,
    required this.children,
    required this.onChanged,
  });

  final T value;
  final Map<T, Widget> children;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: Glass.panel(context, radius: 14),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: SegmentedButton<T>(
          segments: children.entries
              .map(
                (e) => ButtonSegment<T>(
                  value: e.key,
                  label: e.value,
                ),
              )
              .toList(),
          selected: {value},
          onSelectionChanged: (next) {
            if (next.isNotEmpty) onChanged(next.first);
          },
          style: ButtonStyle(
            visualDensity: VisualDensity.compact,
            textStyle: WidgetStatePropertyAll(
              context.eyeTheme.bodySmall.copyWith(fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}
