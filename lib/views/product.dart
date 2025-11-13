import 'dart:math';
import 'dart:ui';

import 'package:ctbkio/main.dart';
import 'package:ctbkio/utils/cart.dart';
import 'package:ctbkio/utils/generalButtons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductPage extends StatelessWidget {
  final Product product;
  const ProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final state = KioScope.of(context);
    final lang = state.lang;
    final colorScheme = Theme.of(context).colorScheme;

    Future<void> handleBooking() async {
      final messenger = ScaffoldMessenger.of(context);
      final addedMessage = t(
        context,
        'Added to cart!',
        '¡Agregado al carrito!',
      );
      final result = await showModalBottomSheet<_BookingResult>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _BookingSheet(product: product),
      );
      if (!context.mounted) return;
      if (result != null && result.qty > 0) {
        state.addToCart(product, qty: result.qty);
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              addedMessage,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: colorScheme.secondary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          const _ProductBackdrop(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final panelWidth = min(constraints.maxWidth, 1100.0);
                  final panelHeight = constraints.maxHeight.isFinite
                      ? constraints.maxHeight
                      : MediaQuery.of(context).size.height;
                  return Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: panelWidth,
                      height: panelHeight,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),
                          border: Border.all(
                            color: colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.35),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              blurRadius: 48,
                              offset: const Offset(0, 32),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 18,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(36),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                            child: Container(
                              color: colorScheme.surface.withValues(
                                alpha: 0.92,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      28,
                                      20,
                                      28,
                                      0,
                                    ),
                                    child: Row(
                                      children: [
                                        const BackButtonCustom(),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                t(
                                                  context,
                                                  'Service detail',
                                                  'Detalle del servicio',
                                                ),
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(
                                                    0xFF475467,
                                                  ),
                                                  fontSize: 12,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                product.title(lang),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const CartButton(),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Divider(
                                    height: 1,
                                    color: Color(0xFFE4E7EC),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      padding: const EdgeInsets.fromLTRB(
                                        28,
                                        24,
                                        28,
                                        32,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          _ProductHeroCard(
                                            product: product,
                                            lang: lang,
                                          ),
                                          const SizedBox(height: 24),
                                          _ProductSummary(
                                            product: product,
                                            lang: lang,
                                          ),
                                          const SizedBox(height: 24),
                                          _DescriptionBlock(
                                            text: product.desc(lang),
                                          ),
                                          if (product.emojis.isNotEmpty) ...[
                                            const SizedBox(height: 24),
                                            _EmojiShowcase(
                                              emojis: product.emojis,
                                            ),
                                          ],
                                        ],
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
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: ElevatedButton.icon(
                onPressed: handleBooking,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(64),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shadowColor: colorScheme.primary.withValues(alpha: 0.45),
                  elevation: 8,
                  textStyle: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                icon: const Icon(Icons.add_shopping_cart_rounded, size: 22),
                label: Text(
                  t(context, 'Book / Add to cart', 'Reservar / Agregar'),
                ),
              ),
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

class _ProductHeroCard extends StatelessWidget {
  final Product product;
  final Language lang;
  const _ProductHeroCard({required this.product, required this.lang});

  @override
  Widget build(BuildContext context) {
    final categoryLabel = categoryName(product.category, lang);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.95, end: 1),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) =>
          Transform.scale(scale: value, child: child),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const _ImageSkeleton();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const _ImageError();
                  },
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withValues(alpha: 0.65),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: _PriceBadge(price: product.priceUsd),
              ),
              Positioned(
                left: 24,
                bottom: 20,
                right: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Text(
                        categoryLabel.toUpperCase(),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      product.title(lang),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductSummary extends StatelessWidget {
  final Product product;
  final Language lang;
  const _ProductSummary({required this.product, required this.lang});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final categoryLabel = categoryName(product.category, lang);
    final price = '\$${product.priceUsd.toStringAsFixed(0)} USD';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.title(lang),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          price,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _InfoPill(
              icon: Icons.category_outlined,
              label: t(context, 'Category', 'Categoría'),
              value: categoryLabel,
            ),
            _InfoPill(
              icon: Icons.schedule_rounded,
              label: t(context, 'Availability', 'Disponibilidad'),
              value: t(context, 'Immediate', 'Inmediata'),
            ),
          ],
        ),
      ],
    );
  }
}

class _DescriptionBlock extends StatelessWidget {
  final String text;
  const _DescriptionBlock({required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.08)),
        color: colorScheme.surface.withValues(alpha: 0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t(context, 'Overview', 'Descripción'),
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.5,
              color: const Color(0xFF475467),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmojiShowcase extends StatelessWidget {
  final List<String> emojis;
  const _EmojiShowcase({required this.emojis});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t(context, 'Mood & highlights', 'Estado y destacados'),
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final emoji in emojis)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 20)),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoPill({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE4E7EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF98A2B3),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF101828),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  final double price;
  const _PriceBadge({required this.price});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: colorScheme.secondary,
        boxShadow: [
          BoxShadow(
            color: colorScheme.secondary.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Text(
        '\$${price.toStringAsFixed(0)}',
        style: GoogleFonts.inter(
          color: Colors.black,
          fontWeight: FontWeight.w800,
          fontSize: 16,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}

class _BookingResult {
  final DateTime date;
  final int qty;
  const _BookingResult(this.date, this.qty);
}

class _BookingSheet extends StatefulWidget {
  final Product product;
  const _BookingSheet({required this.product});

  @override
  State<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<_BookingSheet> {
  DateTime date = DateTime.now().add(const Duration(days: 1));
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: colorScheme.surface.withValues(alpha: 0.96),
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5F5),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    t(
                      context,
                      'Select date & quantity',
                      'Selecciona fecha y cantidad',
                    ),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                              initialDate: date,
                            );
                            if (picked != null) setState(() => date = picked);
                          },
                          icon: const Icon(Icons.today),
                          label: Text(
                            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      _QtyPicker(
                        value: qty,
                        onChanged: (v) => setState(() => qty = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pop(_BookingResult(date, qty)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
                    ),
                    child: Text(t(context, 'Confirm', 'Confirmar')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QtyPicker extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _QtyPicker({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => onChanged(max(1, value - 1)),
            icon: Icon(Icons.remove, color: colorScheme.primary),
          ),
          Text(
            '$value',
            style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          IconButton(
            onPressed: () => onChanged(value + 1),
            icon: Icon(Icons.add, color: colorScheme.primary),
          ),
        ],
      ),
    );
  }
}

class _ProductBackdrop extends StatelessWidget {
  const _ProductBackdrop();

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
          children: const [
            _BlurCircle(
              alignment: Alignment.topLeft,
              size: 260,
              colors: [Color(0x334A90E2), Colors.transparent],
              offset: Offset(-60, -40),
            ),
            _BlurCircle(
              alignment: Alignment.bottomRight,
              size: 320,
              colors: [Color(0x3350E3C2), Colors.transparent],
              offset: Offset(80, 60),
            ),
            _BlurCircle(
              alignment: Alignment.center,
              size: 220,
              colors: [Color(0x33BD10E0), Colors.transparent],
              offset: Offset(0, -20),
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
