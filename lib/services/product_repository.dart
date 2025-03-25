import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductsService {
  static const String baseUrl = 'https://dummyjson.com/products';

  Future<Map<String, dynamic>> fetchProducts(int page, {int limit = 10}) async {
    final response = await http.get(
      Uri.parse('$baseUrl?skip=${page * limit}&limit=$limit'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return {
        'products': (data['products'] as List)
            .map((productJson) => Product.fromJson(productJson))
            .toList(),
        'total': data['total'],
      };
    } else {
      throw Exception('Failed to load products');
    }
  }
}