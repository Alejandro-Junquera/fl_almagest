import 'dart:convert';
import 'package:fl_almagest/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GetProductService extends ChangeNotifier{

  final String _baseUrl = 'semillero.allsites.es';
  final storage = const FlutterSecureStorage();
  final List<Data> products = [];
  bool isLoading = true;

getProducts(String id) async {
    String? token = await storage.read(key: 'token') ?? '';
    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/public/api/products/company', {'company_id': id});
    final resp = await http.post(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    var p = Products.fromJson(decodedResp);
    for (var i in p.data!) {
      if (i.deleted == 0) {
        products.add(i);
      }
    }
    isLoading = false;
    notifyListeners();
  }
}