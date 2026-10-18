import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/cart_item_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState()) {
    on<AddToCart>((event, emit) {
      final updatedItems = state.items
          .map(
            (item) =>
                CartItemModel(product: item.product, quantity: item.quantity),
          )
          .toList();

      final index = updatedItems.indexWhere(
        (item) => item.product.id == event.product.id,
      );

      if (index >= 0) {
        updatedItems[index].quantity++;
      } else {
        updatedItems.add(CartItemModel(product: event.product));
      }

      emit(CartState(items: updatedItems));
    });

    on<RemoveFromCart>((event, emit) {
      final updatedItems = state.items
          .where((item) => item.product.id != event.productId)
          .map(
            (item) =>
                CartItemModel(product: item.product, quantity: item.quantity),
          )
          .toList();

      emit(CartState(items: updatedItems));
    });

    on<ClearCart>((event, emit) {
      emit(CartState());
    });
  }
}
