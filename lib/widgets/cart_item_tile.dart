import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../models/cart_item_model.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    required this.onRemove,
  });

  final CartItemModel item;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 72,
              height: 72,
              child: Image.network(
                item.product.image,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported_outlined),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${item.product.price.toStringAsFixed(2)} × ${item.quantity}',
                  ),
                  Text(
                    '${context.strings.t('total')}: \$${item.subtotal.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: context.strings.t('remove'),
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}
