import 'package:flutter/widgets.dart';

/// A builder widget for creating tooltip content.
///
/// [TooltipContent] provides a structured way to build tooltip content
/// with common patterns like title, value, and description.
class TooltipContent extends StatelessWidget {
  /// The main title text.
  final String? title;

  /// The primary value to display.
  final String? value;

  /// Additional description text.
  final String? description;

  /// The style for the title text.
  final TextStyle? titleStyle;

  /// The style for the value text.
  final TextStyle? valueStyle;

  /// The style for the description text.
  final TextStyle? descriptionStyle;

  /// An optional leading widget (e.g., color indicator).
  final Widget? leading;

  /// An optional trailing widget.
  final Widget? trailing;

  /// The spacing between elements.
  final double spacing;

  /// Custom children to display instead of the structured content.
  final List<Widget>? children;

  /// Creates a TooltipContent widget.
  const TooltipContent({
    super.key,
    this.title,
    this.value,
    this.description,
    this.titleStyle,
    this.valueStyle,
    this.descriptionStyle,
    this.leading,
    this.trailing,
    this.spacing = 4,
    this.children,
  });

  /// Creates a TooltipContent from a map of data.
  factory TooltipContent.fromMap(
    Map<String, dynamic> data, {
    TextStyle? titleStyle,
    TextStyle? valueStyle,
    TextStyle? descriptionStyle,
    String? titleKey = 'title',
    String? valueKey = 'value',
    String? descriptionKey = 'description',
  }) {
    return TooltipContent(
      title: titleKey != null ? data[titleKey]?.toString() : null,
      value: valueKey != null ? data[valueKey]?.toString() : null,
      description:
          descriptionKey != null ? data[descriptionKey]?.toString() : null,
      titleStyle: titleStyle,
      valueStyle: valueStyle,
      descriptionStyle: descriptionStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (children != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children!,
      );
    }

    final content = <Widget>[];

    if (title != null) {
      content.add(Text(
        title!,
        style: titleStyle ??
            const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF),
            ),
      ));
    }

    if (value != null) {
      if (content.isNotEmpty) {
        content.add(SizedBox(height: spacing));
      }
      content.add(Text(
        value!,
        style: valueStyle ??
            const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFFFFFFFF),
            ),
      ));
    }

    if (description != null) {
      if (content.isNotEmpty) {
        content.add(SizedBox(height: spacing));
      }
      content.add(Text(
        description!,
        style: descriptionStyle ??
            const TextStyle(
              fontSize: 11,
              color: Color(0xFFCCCCCC),
            ),
      ));
    }

    Widget result = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: content,
    );

    if (leading != null || trailing != null) {
      result = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: spacing * 2),
          ],
          Flexible(child: result),
          if (trailing != null) ...[
            SizedBox(width: spacing * 2),
            trailing!,
          ],
        ],
      );
    }

    return result;
  }
}

/// A widget that displays multiple tooltip items.
///
/// Useful for displaying data from multiple series at once.
class TooltipContentList extends StatelessWidget {
  /// The items to display.
  final List<TooltipItem> items;

  /// The spacing between items.
  final double itemSpacing;

  /// The maximum number of items to display.
  final int? maxItems;

  /// Text to display when there are more items than maxItems.
  final String? overflowText;

  /// Style for the overflow text.
  final TextStyle? overflowStyle;

  /// Creates a TooltipContentList widget.
  const TooltipContentList({
    super.key,
    required this.items,
    this.itemSpacing = 8,
    this.maxItems,
    this.overflowText,
    this.overflowStyle,
  });

  @override
  Widget build(BuildContext context) {
    final displayItems = maxItems != null && items.length > maxItems!
        ? items.take(maxItems!)
        : items;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...displayItems.map((item) => Padding(
              padding: EdgeInsets.only(bottom: itemSpacing),
              child: _TooltipItemWidget(item: item),
            )),
        if (maxItems != null && items.length > maxItems!)
          Text(
            overflowText ?? '... and ${items.length - maxItems!} more',
            style: overflowStyle ??
                const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF999999),
                  fontStyle: FontStyle.italic,
                ),
          ),
      ],
    );
  }
}

/// A single tooltip item with optional color indicator.
class TooltipItem {
  /// The label for this item.
  final String label;

  /// The value for this item.
  final String value;

  /// The color associated with this item.
  final Color? color;

  /// Additional metadata.
  final Map<String, dynamic>? metadata;

  /// Creates a TooltipItem.
  const TooltipItem({
    required this.label,
    required this.value,
    this.color,
    this.metadata,
  });
}

class _TooltipItemWidget extends StatelessWidget {
  final TooltipItem item;

  const _TooltipItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (item.color != null) ...[
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: item.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          '${item.label}: ',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFFCCCCCC),
          ),
        ),
        Text(
          item.value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFFFFFFFF),
          ),
        ),
      ],
    );
  }
}

/// A builder function type for creating tooltip content from data.
typedef TooltipBuilder<T> = Widget Function(BuildContext context, T data);

/// A wrapper that builds tooltip content using a builder function.
class TooltipContentBuilder<T> extends StatelessWidget {
  /// The data to pass to the builder.
  final T data;

  /// The builder function.
  final TooltipBuilder<T> builder;

  /// Creates a TooltipContentBuilder widget.
  const TooltipContentBuilder({
    super.key,
    required this.data,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, data);
  }
}
