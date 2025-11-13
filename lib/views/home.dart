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
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: panelMaxWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      children: [
                        const HelpButton(),
                        const Expanded(child: Center(child: LangPill())),
                        const CartButton(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      Text(
                        "KIO",
                        style: GoogleFonts.inter(
                          color: Theme.of(context).colorScheme.primary,
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
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                              letterSpacing: -0.2,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const KioskSearchBar(),
                  ),
                  const SizedBox(height: 48),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
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
                              return _KioskFeatureCard(
                                title: f.title,
                                subtitle: _subtitleFor(f.category, context),
                                accent: f.colorStart,
                                icon: f.icon,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CatalogPage(category: f.category),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                            minimumSize: const Size.fromHeight(52),
                            padding: const EdgeInsets.symmetric(vertical: 12),
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
class _KioskFeatureCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final subtitleStyle = GoogleFonts.inter(
      color: const Color(0xFF667085),
      height: 1.25,
    );

    return Material(
      color: Colors.white,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE4E7EC), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, size: 32, color: accent),
                ),
                Spacer(),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24,
                  ),
                ),
                if (subtitle != null) ...[
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: subtitleStyle,
                  ),
                ],
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
