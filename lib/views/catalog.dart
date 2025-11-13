import 'dart:ui';

import 'package:ctbkio/main.dart';
import 'package:ctbkio/models/category.dart';
import 'package:ctbkio/utils/cart.dart';
import 'package:ctbkio/utils/generalButtons.dart';
import 'package:ctbkio/utils/search_bar.dart';
import 'package:ctbkio/views/product.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CatalogPage extends StatefulWidget {
  final KioCategory? category;
  final String? query;
  const CatalogPage({super.key, this.category, this.query});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late final TextEditingController _searchController;
  String _query = '';
  KioCategory? _category;

  @override
  void initState() {
    super.initState();
    _query = widget.query ?? '';
    _category = widget.category;
    _searchController = TextEditingController(text: _query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_query == value) return;
    setState(() => _query = value);
  }

  void _clearSearch() {
    if (_query.isEmpty) return;
    _searchController.clear();
    _onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final lang = KioScope.of(context).lang;

    List<Product> list = products;
    if (_category != null) {
      list = list.where((p) => p.category == _category).toList();
    }
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list
          .where(
            (p) =>
                p.title(lang).toLowerCase().contains(q) ||
                p.desc(lang).toLowerCase().contains(q),
          )
          .toList();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final title = _category == null
        ? t(context, 'All Services', 'Todos los Servicios')
        : categoryName(_category!, lang);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          const _CatalogBackdrop(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.35,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          blurRadius: 48,
                          offset: const Offset(0, 32),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: Container(
                          color: colorScheme.surface.withValues(alpha: 0.92),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  28,
                                  24,
                                  28,
                                  8,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface.withValues(
                                      alpha: 0.75,
                                    ),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: colorScheme.primary.withValues(
                                        alpha: 0.08,
                                      ),
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
                                      const BackButtonCustom(),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 350,
                                          ),
                                          child: Text(
                                            title,
                                            key: ValueKey(title),
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w800,
                                                  letterSpacing: -0.2,
                                                ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const CartButton(),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 28,
                                ),
                                child: KioskSearchBar(
                                  controller: _searchController,
                                  onChanged: _onSearchChanged,
                                  onSubmitted: _onSearchChanged,
                                  onClear: _clearSearch,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: _Filters(
                                  active: _category,
                                  onTap: (c) => setState(() => _category = c),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Expanded(
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 320),
                                  switchInCurve: Curves.easeOutCubic,
                                  switchOutCurve: Curves.easeInCubic,
                                  child: list.isEmpty
                                      ? _EmptyState(
                                          message: t(
                                            context,
                                            'No results found',
                                            'No se encontraron resultados',
                                          ),
                                        )
                                      : ListView.separated(
                                          key: ValueKey(
                                            '${_category?.name}-$_query-${list.length}',
                                          ),
                                          padding: const EdgeInsets.only(
                                            bottom: 32,
                                          ),
                                          itemCount: list.length,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(height: 24),
                                          itemBuilder: (context, i) =>
                                              TweenAnimationBuilder<double>(
                                                tween: Tween(begin: 0, end: 1),
                                                duration: Duration(
                                                  milliseconds: 450 + (i * 60),
                                                ),
                                                curve: Curves.easeOutCubic,
                                                builder:
                                                    (context, value, child) =>
                                                        Transform.translate(
                                                          offset: Offset(
                                                            0,
                                                            (1 - value) * 28,
                                                          ),
                                                          child: Opacity(
                                                            opacity: value,
                                                            child: child,
                                                          ),
                                                        ),
                                                child: _ProductListCard(
                                                  product: list[i],
                                                ),
                                              ),
                                        ),
                                ),
                              ),
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
}

class _Filters extends StatelessWidget {
  final KioCategory? active;
  final ValueChanged<KioCategory?> onTap;
  const _Filters({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final lang = KioScope.of(context).lang;
    final cats = KioCategory.values;
    final colorScheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(32);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.85),
            border: Border.all(color: const Color(0xFFE4E7EC)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _FilterChip(
                  label: t(context, 'All', 'Todo'),
                  selected: active == null,
                  onTap: () => onTap(null),
                ),
                const SizedBox(width: 10),
                for (final c in cats) ...[
                  _FilterChip(
                    label: categoryName(c, lang),
                    selected: active == c,
                    onTap: () => onTap(c),
                  ),
                  const SizedBox(width: 10),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(999);
    final gradient = LinearGradient(
      colors: [
        colorScheme.primary.withValues(alpha: 0.9),
        colorScheme.secondary.withValues(alpha: 0.65),
      ],
    );

    return AnimatedScale(
      scale: selected ? 1.02 : 1,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: selected ? gradient : null,
          color: selected ? null : Colors.white.withValues(alpha: 0.95),
          border: Border.all(
            color: selected
                ? colorScheme.primary.withValues(alpha: 0.5)
                : const Color(0xFFE5E7EB),
          ),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 14,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : const Color(0xFF344054),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductListCard extends StatefulWidget {
  final Product product;
  const _ProductListCard({required this.product});

  @override
  State<_ProductListCard> createState() => _ProductListCardState();
}

class _ProductListCardState extends State<_ProductListCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final lang = KioScope.of(context).lang;
    final product = widget.product;
    final colorScheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.zero;

    return AnimatedScale(
      scale: _pressed ? 0.99 : 1,
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutQuad,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          color: Colors.white.withValues(alpha: 0.96),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.12),
              blurRadius: 36,
              offset: const Offset(0, 28),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: radius,
            onHighlightChanged: (value) => setState(() => _pressed = value),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ProductPage(product: product)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: radius,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const _ImageSkeleton();
                          },
                          errorBuilder: (context, error, stack) {
                            return const _ImageError();
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withValues(alpha: 0.55),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          bottom: 16,
                          right: 20,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  product.title(lang),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              _PricePill(price: product.priceUsd),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.desc(lang),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF475467),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: [
                          for (final emoji in product.emojis)
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: colorScheme.secondary.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE4E7EC)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: Row(
                    children: [
                      Icon(Icons.category_outlined, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          categoryName(product.category, lang),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProductPage(product: product),
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.primary,
                          textStyle: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                        label: Text(t(context, 'View', 'Ver')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageSkeleton extends StatelessWidget {
  const _ImageSkeleton();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE5E7EB),
      child: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _ImageError extends StatelessWidget {
  const _ImageError();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE5E7EB),
      child: Center(
        child: Icon(Icons.broken_image_outlined, size: 48, color: Colors.grey),
      ),
    );
  }
}

class _PricePill extends StatelessWidget {
  final double price;
  const _PricePill({required this.price});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: colorScheme.secondary,
        boxShadow: [
          BoxShadow(
            color: colorScheme.secondary.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Text(
        '\$${price.toStringAsFixed(0)}',
        style: GoogleFonts.inter(
          color: Colors.black,
          fontWeight: FontWeight.w800,
          fontSize: 14,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: colorScheme.primary.withValues(alpha: 0.1)),
          color: colorScheme.surface.withValues(alpha: 0.92),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 32,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 36,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t(
                context,
                'Try adjusting your filters or search terms to discover more services.',
                'Ajusta tus filtros o términos de búsqueda para descubrir más servicios.',
              ),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: const Color(0xFF475467)),
            ),
          ],
        ),
      ),
    );
  }
}

class _CatalogBackdrop extends StatelessWidget {
  const _CatalogBackdrop();

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
              alignment: Alignment.topLeft,
              size: 260,
              colors: [
                colorScheme.primary.withValues(alpha: 0.3),
                Colors.transparent,
              ],
              offset: const Offset(-80, -20),
            ),
            _BlurCircle(
              alignment: Alignment.bottomRight,
              size: 320,
              colors: [
                colorScheme.secondary.withValues(alpha: 0.35),
                colorScheme.secondary.withValues(alpha: 0.08),
              ],
              offset: const Offset(60, 60),
            ),
            _BlurCircle(
              alignment: Alignment.center,
              size: 220,
              colors: [
                colorScheme.tertiary.withValues(alpha: 0.25),
                Colors.transparent,
              ],
              offset: const Offset(0, -10),
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
                sigmaX: size * 0.18,
                sigmaY: size * 0.18,
              ),
              child: const SizedBox(),
            ),
          ),
        ),
      ),
    );
  }
}
