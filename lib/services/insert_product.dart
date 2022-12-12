import 'dart:convert';
import 'package:fl_almagest/services/auth_service.dart';
import 'package:fl_almagest/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:fl_almagest/models/models.dart';

class ProductService extends ChangeNotifier {
  final String _baseUrl = 'semillero.allsites.es';
  bool isLoading = true;

  Future<String> setProduct(int article_id, double price, int family_id) async {
    final url = Uri.http(_baseUrl, '/public/api/products');
    String? token = await AuthService().readToken();
    String? company_id = await UserAloneService().readCompany_id();
    final Map<String, dynamic> productData = {
      'company_id': company_id,
      'article_id': article_id,
      'price': price,
      'family_id': family_id
    };
    isLoading = true;
    final resp = await http.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token"
      },
      body: json.encode(productData),
    );
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    isLoading = false;
    notifyListeners();
    return decodedResp['data']['id'].toString();
  }
}
