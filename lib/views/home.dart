import 'dart:ui';

import 'package:ctbkio/main.dart';
import 'package:ctbkio/models/category.dart';
import 'package:ctbkio/models/feature.dart';
import 'package:ctbkio/utils/cart.dart';
import 'package:ctbkio/utils/home/helpButton.dart';
import 'package:ctbkio/utils/langPill.dart';
import 'package:ctbkio/utils/searchBar.dart';
import 'package:ctbkio/views/catalog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LibraryHome extends StatelessWidget {
  const LibraryHome({super.key});

  @override
  Widget build(BuildContext context) {
    const panelMaxWidth = 900.0;

    final items = <Feature>[
      Feature(
        'Conecta',
        Color(0xFF4A90E2),
        Color(0xFF2C578A),
        Icons.hub,
        KioCategory.conecta,
      ),
      Feature(
        'Vive',
        Color(0xFF50E3C2),
        Color(0xFF2A8C74),
        Icons.beach_access,
        KioCategory.vive,
      ),
      Feature(
        'Institucional',
        Color(0xFFF5A623),
        Color(0xFFB0781A),
        Icons.account_balance,
        KioCategory.institucional,
      ),
      Feature(
        'Impulsa',
        Color(0xFFBD10E0),
        Color(0xFF790A93),
        Icons.rocket_launch,
        KioCategory.impulsa,
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          const _HomeBackdrop(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: panelMaxWidth),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.08),
                        blurRadius: 48,
                        offset: const Offset(0, 32),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        color: Theme.of(
                          context,
                        ).colorScheme.surface.withValues(alpha: 0.92),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 24,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface
                                        .withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 0.08),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 24,
                                        offset: const Offset(0, 16),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const HelpButton(),
                                      const Expanded(
                                        child: Center(child: LangPill()),
                                      ),
                                      const CartButton(),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Column(
                                children: [
                                  Text(
                                    "KIO",
                                    style: GoogleFonts.inter(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    t(
                                      context,
                                      "What do you want today?",
                                      "¿Qué quieres hacer hoy?",
                                    ),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          fontWeight: FontWeight.w800,
                                          height: 1.15,
                                          letterSpacing: -0.2,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: 0.08),
                                        blurRadius: 30,
                                        offset: const Offset(0, 20),
                                      ),
                                    ],
                                  ),
                                  child: const KioskSearchBar(),
                                ),
                              ),
                              const SizedBox(height: 48),
                              Expanded(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: GridView.builder(
                                        padding: EdgeInsets.zero,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: items.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 0,
                                              mainAxisSpacing: 0,
                                              childAspectRatio: 0.9,
                                            ),
                                        itemBuilder: (context, i) {
                                          final f = items[i];
                                          return TweenAnimationBuilder<double>(
                                            tween: Tween(begin: 0, end: 1),
                                            duration: Duration(
                                              milliseconds: 500 + (i * 90),
                                            ),
                                            curve: Curves.easeOutCubic,
                                            builder: (context, value, child) {
                                              return Transform.translate(
                                                offset: Offset(
                                                  0,
                                                  (1 - value) * 20,
                                                ),
                                                child: Opacity(
                                                  opacity: value,
                                                  child: child,
                                                ),
                                              );
                                            },
                                            child: _KioskFeatureCard(
                                              title: f.title,
                                              subtitle: _subtitleFor(
                                                f.category,
                                                context,
                                              ),
                                              accent: f.colorStart,
                                              icon: f.icon,
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (_) => CatalogPage(
                                                      category: f.category,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            0,
                                          ),
                                        ),
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        foregroundColor: Theme.of(
                                          context,
                                        ).colorScheme.surface,
                                        minimumSize: const Size.fromHeight(52),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        textStyle: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      child: const Text('VER TODOS'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _subtitleFor(KioCategory c, BuildContext context) {
    switch (c) {
      case KioCategory.conecta:
        return t(
          context,
          "Connectivity & services",
          "Conectividad y servicios",
        );
      case KioCategory.vive:
        return t(context, "Experiences & wellness", "Experiencias y bienestar");
      case KioCategory.institucional:
        return t(context, "Government & campus", "Gobierno y campus");
      case KioCategory.impulsa:
        return t(context, "Business & growth", "Negocios y crecimiento");
    }
  }
}

/// Tarjeta blanca con sombras suaves, icono tintado y esquinas grandes.
class _KioskFeatureCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  const _KioskFeatureCard({
    required this.title,
    required this.icon,
    required this.accent,
    required this.onTap,
    this.subtitle,
  });

  @override
  State<_KioskFeatureCard> createState() => _KioskFeatureCardState();
}

class _KioskFeatureCardState extends State<_KioskFeatureCard> {
  bool _hovering = false;
  bool _pressed = false;

  void _setHovering(bool value) {
    if (_hovering == value) return;
    setState(() => _hovering = value);
  }

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final subtitleStyle = GoogleFonts.inter(
      color: const Color(0xFF667085),
      height: 1.25,
    );

    final isActive = _hovering || _pressed;
    final borderRadius = BorderRadius.zero;
    final accent = widget.accent;

    return MouseRegion(
      onEnter: (_) => _setHovering(true),
      onExit: (_) => _setHovering(false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
        scale: isActive ? 1.02 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            border: Border.all(
              color: isActive
                  ? accent.withValues(alpha: 0.45)
                  : const Color(0xFFE4E7EC),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: isActive ? 0.35 : 0.18),
                blurRadius: isActive ? 32 : 18,
                offset: const Offset(0, 22),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: borderRadius,
              onHighlightChanged: _setPressed,
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            accent.withValues(alpha: 0.25),
                            accent.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: accent.withValues(alpha: 0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),
                      child: Icon(widget.icon, size: 32, color: accent),
                    ),
                    const Spacer(),
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 24,
                      ),
                    ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.subtitle!,
                        textAlign: TextAlign.center,
                        style: subtitleStyle,
                      ),
                    ],
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeBackdrop extends StatelessWidget {
  const _HomeBackdrop();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary.withValues(alpha: 0.08),
              colorScheme.surfaceContainerHighest.withValues(alpha: 0.04),
            ],
          ),
        ),
        child: Stack(
          children: [
            _BlurCircle(
              alignment: Alignment.topRight,
              size: 260,
              colors: [
                colorScheme.primary.withValues(alpha: 0.35),
                colorScheme.primary.withValues(alpha: 0.05),
              ],
              offset: const Offset(80, -40),
            ),
            _BlurCircle(
              alignment: Alignment.bottomLeft,
              size: 320,
              colors: [
                colorScheme.secondary.withValues(alpha: 0.3),
                colorScheme.secondary.withValues(alpha: 0.05),
              ],
              offset: const Offset(-60, 60),
            ),
            _BlurCircle(
              alignment: Alignment.center,
              size: 220,
              colors: [
                colorScheme.tertiary.withValues(alpha: 0.25),
                Colors.transparent,
              ],
              offset: const Offset(0, -40),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlurCircle extends StatelessWidget {
  final Alignment alignment;
  final List<Color> colors;
  final double size;
  final Offset offset;

  const _BlurCircle({
    required this.alignment,
    required this.colors,
    required this.size,
    this.offset = Offset.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: offset,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: colors),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: size * 0.12,
                sigmaY: size * 0.12,
              ),
              child: const SizedBox(),
            ),
          ),
        ),
      ),
    );
  }
}
