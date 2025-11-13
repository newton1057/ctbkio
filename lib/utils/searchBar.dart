import 'package:ctbkio/main.dart';
import 'package:flutter/material.dart';


class KioskSearchBar extends StatelessWidget {
  const KioskSearchBar();

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFFE4E7EC);
    final radius = BorderRadius.circular(24);

    return Material(
      color: Theme.of(context).colorScheme.secondary, // fondo del pill
      elevation: 3,                                   // sombra suave (equiv. a tu BoxShadow)
      shadowColor: const Color(0x33000000),
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: const BorderSide(color: borderColor, width: 1),
      ),
      clipBehavior: Clip.antiAlias, // ← el cursor/selección quedan recortados al mismo radio
      child: TextField(
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search_rounded),
          hintText: t(context, "Search products and services…", "Busca productos y servicios…"),
          hintStyle: const TextStyle(color: Color(0xFF98A2B3)),
          border: InputBorder.none,
          isCollapsed: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        onSubmitted: (v) {},
      ),
    );
  }
}
