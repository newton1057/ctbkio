import 'package:ctbkio/main.dart';
import 'package:flutter/material.dart';

class CartButton extends StatelessWidget {
  final Color? backgroundColor;
  const CartButton({super.key, this.backgroundColor});
  @override
  Widget build(BuildContext context) {
    final state = KioScope.of(context);
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_bag_outlined),
          iconSize: 32,
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const CartPage())),
        ),
        if (state.cart.isNotEmpty)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
              child: Center(
                child: Text(
                  '${state.cart.fold<int>(0, (sum, item) => sum + item.qty)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}