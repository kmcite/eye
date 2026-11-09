import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:eye/ui/glass.dart';
import 'package:eye/ui/icons.dart';
import 'package:eye/ui/theme.dart';

class EyeTextField extends StatelessWidget {
  const EyeTextField({
    super.key,
    this.controller,
    this.placeholder,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.autofocus = false,
    this.readOnly = false,
    this.inputFormatters,
  });

  final TextEditingController? controller;
  final String? placeholder;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final int maxLines;
  final bool autofocus;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;

  static const _radius = 12.0;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: Glass.panel(context, radius: _radius),
      child: Material(
        type: MaterialType.transparency,
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(_radius),
        child: TextField(
          controller: controller,
          autofocus: autofocus,
          readOnly: readOnly,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          style: context.eyeTheme.body.copyWith(fontSize: 16),
          cursorColor: context.eyeTheme.primary,
          decoration: InputDecoration(
            hintText: placeholder,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
        ),
      ),
    );
  }
}

/// Caption + [EyeTextField] for forms (auth, settings).
class EyeFieldGroup extends StatelessWidget {
  const EyeFieldGroup({
    super.key,
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: context.eyeTheme.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: context.eyeTheme.label,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class EyeSearchField extends StatelessWidget {
  const EyeSearchField({
    super.key,
    required this.placeholder,
    required this.onChanged,
    this.controller,
  });

  final String placeholder;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final theme = context.eyeTheme;
    const radius = 12.0;
    return DecoratedBox(
      decoration: Glass.panel(context, radius: radius),
      child: Material(
        type: MaterialType.transparency,
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(radius),
        child: TextField(
          controller: controller,
          style: theme.body.copyWith(fontSize: 16),
          cursorColor: theme.primary,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: placeholder,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            prefixIcon:
                Icon(EyeIcons.search, size: 20, color: theme.secondaryLabel),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
