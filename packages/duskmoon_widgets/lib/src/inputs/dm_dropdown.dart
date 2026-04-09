import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:duskmoon_theme/duskmoon_theme.dart';
import '../adaptive/fluent_theme_bridge.dart';

/// A selectable item for use in [DmDropdown].
class DmDropdownItem<T> {
  /// Creates a dropdown item with a [value] and display [child].
  const DmDropdownItem({required this.value, required this.child});

  /// The value this item represents.
  final T value;

  /// The widget displayed for this item.
  final Widget child;
}

/// An adaptive dropdown that renders Material, Cupertino, or Fluent styles.
///
/// On Material, renders a [DropdownButton].
/// On Cupertino, renders a button that opens a [CupertinoPicker] modal.
/// On Fluent, renders a [fluent.ComboBox].
class DmDropdown<T> extends StatelessWidget with AdaptiveWidget {
  /// Creates an adaptive dropdown.
  const DmDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.placeholder,
    this.isExpanded = true,
    this.platformOverride,
  });

  /// The list of selectable items.
  final List<DmDropdownItem<T>> items;

  /// Called when the user selects an item.
  final ValueChanged<T?>? onChanged;

  /// The currently selected value, or `null` for no selection.
  final T? value;

  /// Placeholder text shown when no item is selected.
  final String? placeholder;

  /// Whether the dropdown expands to fill its parent width.
  final bool isExpanded;

  @override
  final DmPlatformStyle? platformOverride;

  @override
  Widget build(BuildContext context) {
    return switch (resolveStyle(context)) {
      DmPlatformStyle.material => _buildMaterial(context),
      DmPlatformStyle.cupertino => _buildCupertino(context),
      DmPlatformStyle.fluent => _buildFluent(context),
    };
  }

  Widget _buildMaterial(BuildContext context) {
    return DropdownButton<T>(
      value: value,
      isExpanded: isExpanded,
      hint: placeholder != null ? Text(placeholder!) : null,
      onChanged: onChanged,
      items: items
          .map((item) => DropdownMenuItem<T>(
                value: item.value,
                child: item.child,
              ))
          .toList(),
    );
  }

  Widget _buildCupertino(BuildContext context) {
    final selectedItem = items.cast<DmDropdownItem<T>?>().firstWhere(
          (item) => item!.value == value,
          orElse: () => null,
        );

    return GestureDetector(
      onTap: onChanged == null ? null : () => _showCupertinoPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: CupertinoColors.separator.resolveFrom(context),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          children: [
            Expanded(
              child: selectedItem != null
                  ? selectedItem.child
                  : Text(
                      placeholder ?? '',
                      style: TextStyle(
                        color: CupertinoColors.placeholderText
                            .resolveFrom(context),
                      ),
                    ),
            ),
            Icon(
              CupertinoIcons.chevron_down,
              size: 16,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showCupertinoPicker(BuildContext context) {
    final selectedIndex =
        items.indexWhere((item) => item.value == value).clamp(0, items.length - 1);

    showCupertinoModalPopup<void>(
      context: context,
      builder: (pickerContext) => _CupertinoPickerSheet<T>(
        items: items,
        initialIndex: selectedIndex,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildFluent(BuildContext context) {
    return wrapWithFluentTheme(
      context,
      fluent.ComboBox<T>(
        value: value,
        isExpanded: isExpanded,
        placeholder: placeholder != null ? Text(placeholder!) : null,
        onChanged: onChanged,
        items: items
            .map((item) => fluent.ComboBoxItem<T>(
                  value: item.value,
                  child: item.child,
                ))
            .toList(),
      ),
    );
  }
}

class _CupertinoPickerSheet<T> extends StatefulWidget {
  const _CupertinoPickerSheet({
    required this.items,
    required this.initialIndex,
    required this.onChanged,
  });

  final List<DmDropdownItem<T>> items;
  final int initialIndex;
  final ValueChanged<T?>? onChanged;

  @override
  State<_CupertinoPickerSheet<T>> createState() =>
      _CupertinoPickerSheetState<T>();
}

class _CupertinoPickerSheetState<T> extends State<_CupertinoPickerSheet<T>> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoButton(
                child: const Text('Done'),
                onPressed: () {
                  widget.onChanged?.call(widget.items[_selectedIndex].value);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          Expanded(
            child: CupertinoPicker(
              scrollController:
                  FixedExtentScrollController(initialItem: _selectedIndex),
              itemExtent: 32,
              onSelectedItemChanged: (index) => _selectedIndex = index,
              children:
                  widget.items.map((item) => Center(child: item.child)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
