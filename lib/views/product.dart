import 'dart:math';

import 'package:ctbkio/main.dart';
import 'package:ctbkio/utils/appBackground.dart';
import 'package:ctbkio/utils/cart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductPage extends StatelessWidget {
  final Product product;
  const ProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final state = KioScope.of(context);
    final lang = state.lang;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: AppBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250.0,
              pinned: true,
              backgroundColor: const Color(0xFFF4F7FC),
              foregroundColor: Theme.of(context).colorScheme.primary,
              surfaceTintColor: Colors.transparent,
              elevation: 2,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BackButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.white.withOpacity(0.8)))),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CartButton(
                      backgroundColor: Colors.white.withOpacity(0.8)),
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const _ImageSkeleton();
                  },
                  errorBuilder: (context, error, stack) => const _ImageError(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.title(lang),
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '\$${product.priceUsd.toStringAsFixed(0)}',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        for (final e in product.emojis)
                          Text(e, style: const TextStyle(fontSize: 24)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      product.desc(lang),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.5, color: const Color(0xFF475467)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () async {
              final result = await showModalBottomSheet<_BookingResult>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (_) => _BookingSheet(product: product),
              );
              if (result != null && result.qty > 0) {
                state.addToCart(product, qty: result.qty);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      t(context, 'Added to cart!', '¡Agregado al carrito!'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            icon: const Icon(Icons.add_shopping_cart_rounded, size: 20),
            label: Text(
              t(context, 'Book / Add to cart', 'Reservar / Agregar'),
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
              color: Theme.of(context).colorScheme.primary)),
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
          child:
              Icon(Icons.broken_image_outlined, size: 48, color: Colors.grey)),
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
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              t(context, 'Select date & quantity', 'Selecciona fecha y cantidad'),
              style: Theme.of(context).textTheme.headlineSmall,
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
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        initialDate: date,
                      );
                      if (picked != null) setState(() => date = picked);
                    },
                    icon: const Icon(Icons.today),
                    label: Text(
                      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pop(_BookingResult(date, qty)),
              child: Text(t(context, 'Confirm', 'Confirmar')),
            ),
          ],
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => onChanged(max(1, value - 1)),
            icon: Icon(Icons.remove,
                color: Theme.of(context).colorScheme.primary),
          ),
          Text('$value', style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 16)),
          IconButton(
            onPressed: () => onChanged(value + 1),
            icon:
                Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }
}