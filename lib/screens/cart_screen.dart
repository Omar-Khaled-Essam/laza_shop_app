import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../l10n/app_strings.dart';
import '../widgets/cart_item_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('cart')),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) => IconButton(
              tooltip: strings.t('clearCart'),
              onPressed: state.items.isEmpty
                  ? null
                  : () => context.read<CartBloc>().add(ClearCart()),
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
          ),
        ],
      ),
      body: BlocListener<CartBloc, CartState>(
        listenWhen: (previous, current) =>
            previous.items.isNotEmpty && current.items.isEmpty,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(strings.t('emptyNotice'))),
          );
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      strings.t('emptyCart'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return CartItemTile(
                        item: item,
                        onRemove: () => context
                            .read<CartBloc>()
                            .add(RemoveFromCart(item.product.id)),
                      );
                    },
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .06),
                          blurRadius: 12,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              strings.t('total'),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '\$${state.totalPrice.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(strings.t('checkoutDemo'))),
                            ),
                            child: Text(strings.t('checkout')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
