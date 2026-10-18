import '../../models/cart_item_model.dart';

class CartState {
  CartState({this.items = const []});

  final List<CartItemModel> items;

  int get totalQuantity =>
      items.fold(0, (total, item) => total + item.quantity);

  double get totalPrice =>
      items.fold(0, (total, item) => total + item.subtotal);
}
