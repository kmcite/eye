import 'package:eye/business/categories_notifier.dart';
import 'package:eye/ui/eye_ui.dart';
import 'package:eye/utils/infrastructure.dart';
import 'package:eye/utils/router.dart';
import 'package:flutter/material.dart';

class NewCategoryDialog extends SignalConsumer {
  const NewCategoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = categoriesNotifierProvider();
    final editing = categories.selected();

    Future<void> save() async {
      if (!categories.canSave()) return;
      try {
        if (editing == null) {
          await categories.create();
        } else {
          await categories.update(editing);
        }
        router.pop();
      } catch (_) {}
    }

    return EyeDialog(
      title: editing == null ? 'New topic' : 'Rename topic',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (categories.error() != null) ...[
            InlineMessage.error(categories.error().toString()),
            const SizedBox(height: 8),
          ],
          EyeFieldGroup(
            label: 'Name',
            child: EyeTextField(
              autofocus: true,
              placeholder: 'Topic name',
              onChanged: categories.name.set,
              onSubmitted: (_) => save(),
            ),
          ),
        ],
      ),
      actions: [
        EyeTextButton(label: 'Cancel', onPressed: () => router.pop()),
        categories.isSaving()
            ? const SizedBox(
                width: 48,
                height: 48,
                child: Center(child: EyeSpinner()),
              )
            : EyePrimaryButton(
                label: editing == null ? 'Create' : 'Save',
                onPressed: categories.canSave() ? save : null,
              ),
      ],
    );
  }
}
