import 'package:ctbkio/main.dart';
import 'package:ctbkio/models/category.dart';
import 'package:ctbkio/utils/appBackground.dart';
import 'package:ctbkio/utils/cart.dart';
import 'package:ctbkio/utils/generalButtons.dart';
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
  String? _query;
  KioCategory? _category;

  @override
  void initState() {
    super.initState();
    _query = widget.query;
    _category = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    final lang = KioScope.of(context).lang;

    List<Product> list = products;
    if (_category != null) {
      list = list.where((p) => p.category == _category).toList();
    }
    if ((_query ?? '').isNotEmpty) {
      final q = _query!.toLowerCase();
      list = list
          .where(
            (p) =>
                p.title(lang).toLowerCase().contains(q) ||
                p.desc(lang).toLowerCase().contains(q),
          )
          .toList();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const BackButtonCustom(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _category == null
                          ? t(context, 'All Services', 'Todos los Servicios')
                          : categoryName(_category!, lang),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const CartButton(),
                ],
              ),
            ),
            _Filters(
              active: _category,
              onTap: (c) => setState(() => _category = c),
            ),
            Expanded(
              child: list.isEmpty 
              ? Center(child: Text(t(context, 'No results found', 'No se encontraron resultados')))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _ProductListCard(product: list[i]),
                ),
              ),
            ),
          ],
        ),
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
    return SingleChildScrollView(
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Colors.white,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : const Color(0xFFE5E7EB),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : const Color(0xFF344054),
          ),
        ),
      ),
    );
  }
}


class _ProductListCard extends StatelessWidget {
  final Product product;
  const _ProductListCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final lang = KioScope.of(context).lang;
    return InkWell(
      onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ProductPage(product: product))),
      borderRadius: BorderRadius.circular(24),
      child: Card(
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image with overlay
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
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
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                        ),
                      ),
                    ),
                    // Price Tag
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '\$${product.priceUsd.toStringAsFixed(0)}',
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title(lang),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.desc(lang),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF475467), height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: -4,
                    children: [
                      for (final e in product.emojis)
                        Text(e, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
