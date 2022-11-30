import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class InsertProductService extends ChangeNotifier{
  final String _baseUrl = 'semillero.allsites.es';
  final storage = const FlutterSecureStorage();

  insertProduct(String articleId, String companyId, String price, int familyId) async{
    String? token = await storage.read(key: 'token') ?? '';
    final Map<String, dynamic> authData = {
      'article_id': articleId,
      'company_id': companyId,
      'price': price,
      'family_id': familyId,
    };
    final url = Uri.http(_baseUrl, '/public/api/products', {});
    final resp = await http.post(url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    if (decodedResp['success'] == true) {
      return decodedResp['message'];
    }
  }
}