import '../../models/product_model.dart';

abstract class CartEvent {}

class AddToCart extends CartEvent {
  AddToCart(this.product);

  final ProductModel product;
}

class RemoveFromCart extends CartEvent {
  RemoveFromCart(this.productId);

  final int productId;
}

class ClearCart extends CartEvent {}
