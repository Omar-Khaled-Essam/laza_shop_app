import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../l10n/app_strings.dart';
import '../models/product_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('details')),
        actions: [
          BlocConsumer<CartBloc, CartState>(
            listenWhen: (previous, current) =>
                current.totalQuantity > previous.totalQuantity,
            listener: (context, state) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(strings.t('added'))));
            },
            builder: (context, state) => IconButton(
              tooltip: strings.t('cart'),
              onPressed: () => Navigator.of(context).pushNamed('/cart'),
              icon: Badge(
                isLabelVisible: state.totalQuantity > 0,
                label: Text('${state.totalQuantity}'),
                child: const Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 280,
                        child: Hero(
                          tag: 'product-${product.id}',
                          child: Image.network(
                            product.image,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.image_not_supported_outlined,
                              size: 64,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      product.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${strings.t('category')}: ${product.category}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      strings.t('description'),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => context.read<CartBloc>().add(AddToCart(product)),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(strings.t('addToCart')),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
