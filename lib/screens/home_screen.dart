import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../blocs/product/product_cubit.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_event.dart';
import '../l10n/app_strings.dart';
import '../widgets/banner_page_view.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onToggleLocale});

  final VoidCallback onToggleLocale;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1000 ? 4 : width >= 650 ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          strings.t('appName'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: strings.t('language'),
            onPressed: onToggleLocale,
            icon: const Icon(Icons.language),
          ),
          IconButton(
            tooltip: strings.t('theme'),
            onPressed: () => context.read<ThemeBloc>().add(ToggleTheme()),
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
          BlocBuilder<CartBloc, CartState>(
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
          const SizedBox(width: 4),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductInitial || state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off, size: 42),
                    const SizedBox(height: 12),
                    Text(strings.t(state.message), textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => context.read<ProductCubit>().loadProducts(),
                      child: Text(strings.t('retry')),
                    ),
                  ],
                ),
              ),
            );
          }

          final loadedState = state as ProductLoaded;
          final products = loadedState.products;

          return RefreshIndicator(
            onRefresh: () => context.read<ProductCubit>().loadProducts(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.t('welcomeBack'),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 14),
                        const BannerPageView(),
                        const SizedBox(height: 18),
                        Text(
                          strings.t('products'),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (loadedState.fromCache)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              strings.t('cachedNotice'),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (products.isEmpty)
                  SliverFillRemaining(
                    child: Center(child: Text(strings.t('noProducts'))),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = products[index];
                          return ProductCard(
                            product: product,
                            onTap: () => Navigator.of(context).pushNamed(
                              '/product-details',
                              arguments: product,
                            ),
                            onAdd: () {
                              context.read<CartBloc>().add(AddToCart(product));
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    content: Text(strings.t('added')),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                            },
                          );
                        },
                        childCount: products.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: width < 380 ? .62 : .68,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
