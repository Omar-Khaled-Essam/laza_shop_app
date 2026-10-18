import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';

class CacheHelper {
  late SharedPreferences _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> saveProducts(List<ProductModel> products) async {
    final jsonList = products.map((product) => product.toJson()).toList();

    await _preferences.setString('cached_products', jsonEncode(jsonList));
  }

  List<ProductModel> readProducts() {
    final cached = _preferences.getString('cached_products');

    if (cached == null) return [];

    try {
      final decoded = jsonDecode(cached) as List<dynamic>;

      return decoded
          .map(
            (item) =>
                ProductModel.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }
}
