import 'package:ctbkio/main.dart';
import 'package:flutter/material.dart';

class KioskSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final String? hintText;
  final EdgeInsetsGeometry? contentPadding;

  const KioskSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.hintText,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    if (controller != null) {
      return ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller!,
        builder: (context, value, _) {
          final hasQuery = value.text.trim().isNotEmpty;
          void defaultClearAction() {
            controller!
              ..clear()
              ..selection = const TextSelection.collapsed(offset: 0);
            onChanged?.call('');
          }

          return _SearchBarBody(
            controller: controller,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            onClear: hasQuery ? (onClear ?? defaultClearAction) : null,
            hintText: hintText,
            contentPadding: contentPadding,
          );
        },
      );
    }
    return _SearchBarBody(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onClear: null,
      hintText: hintText,
      contentPadding: contentPadding,
    );
  }
}

class _SearchBarBody extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final String? hintText;
  final EdgeInsetsGeometry? contentPadding;

  const _SearchBarBody({
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
    required this.hintText,
    required this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFFE4E7EC);
    final radius = BorderRadius.circular(24);

    return Material(
      color: Theme.of(context).colorScheme.secondary,
      elevation: 3,
      shadowColor: const Color(0x33000000),
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: const BorderSide(color: borderColor, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted ?? onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search_rounded),
          hintText:
              hintText ??
              t(
                context,
                "Search products and services…",
                "Busca productos y servicios…",
              ),
          hintStyle: const TextStyle(color: Color(0xFF98A2B3)),
          border: InputBorder.none,
          isCollapsed: true,
          contentPadding:
              contentPadding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          suffixIcon: onClear != null
              ? IconButton(
                  onPressed: onClear,
                  splashRadius: 18,
                  icon: const Icon(Icons.close_rounded, size: 18),
                )
              : null,
        ),
      ),
    );
  }
}
