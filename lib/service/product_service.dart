import 'dart:convert';
import 'package:bonjour/Model/stock_model.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final String apiUrl =
      'http://bonjour.free.nf/modul/stock.php?action=getstock&i=1';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
