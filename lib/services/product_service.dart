import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import '../models/product_model.dart';
import 'cache_helper.dart';

typedef ProductFetchResult = ({List<ProductModel> products, bool fromCache});

class ProductService {
  ProductService(this._cache)
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://fakestoreapi.com',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
          ),
        ) {
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.connectionFactory = (uri, proxyHost, proxyPort) async {
          final host = proxyHost ?? uri.host;
          final port = proxyPort ?? uri.port;
          final addresses = await InternetAddress.lookup(
            host,
            type: InternetAddressType.IPv4,
          );
          return Socket.startConnect(addresses.first, port);
        };
        return client;
      },
    );
  }

  final Dio _dio;
  final CacheHelper _cache;

  Future<ProductFetchResult> fetchProducts() async {
    try {
      final response = await _getWithRetry();

      final data = response.data;

      if (data == null) {
        throw const FormatException('No products returned.');
      }

      final products = data
          .map(
            (item) =>
                ProductModel.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();

      await _cache.saveProducts(products);

      return (products: products, fromCache: false);
    } on DioException catch (e) {
      // Shows the real reason in the VS Code debug console.
      debugPrint(
        'Products request failed: type=${e.type} '
        'status=${e.response?.statusCode} error=${e.error} '
        'body=${e.response?.data} message=${e.message}',
      );
      final cachedProducts = _cache.readProducts();

      if (cachedProducts.isNotEmpty) {
        return (products: cachedProducts, fromCache: true);
      }

      rethrow;
    }
  }

  Future<Response<List<dynamic>>> _getWithRetry() async {
    try {
      return await _dio.get<List<dynamic>>('/products');
    } on DioException catch (e) {
      final retryable = e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError;
      if (!retryable) rethrow;
      debugPrint('Retrying products request once...');
      return _dio.get<List<dynamic>>('/products');
    }
  }

  List<ProductModel> getCachedProducts() {
    return _cache.readProducts();
  }
}
