import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/product_model.dart';
import '../../services/product_service.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  ProductLoaded(this.products, {this.fromCache = false});

  final List<ProductModel> products;
  final bool fromCache;
}

class ProductError extends ProductState {
  ProductError(this.message);

  final String message;
}

class ProductCubit extends Cubit<ProductState> {
  ProductCubit(this._service) : super(ProductInitial());

  final ProductService _service;

  Future<void> loadProducts() async {
    emit(ProductLoading());

    try {
      final (:products, :fromCache) = await _service.fetchProducts();
      emit(ProductLoaded(products, fromCache: fromCache));
    } catch (error, stackTrace) {
      debugPrint('Failed to load products: $error');
      debugPrintStack(stackTrace: stackTrace);
      emit(
        ProductError(
          'Unable to load products. Please check your connection and try again.',
        ),
      );
    }
  }
}
