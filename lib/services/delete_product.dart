import 'dart:convert';
import 'package:fl_almagest/services/auth_service.dart';
import 'package:fl_almagest/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:fl_almagest/models/models.dart';

class DeleteProductService extends ChangeNotifier {
  final String _baseUrl = 'semillero.allsites.es';
  bool isLoading = true;

  Future<String> deleteProduct(int article_id) async {
    final url = Uri.http(_baseUrl, '/public/api/products/$article_id');
    String? token = await AuthService().readToken();
    isLoading = true;
    final resp = await http.delete(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token"
      },
    );

    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);

    isLoading = false;
    notifyListeners();
    return decodedResp['message'].toString();
  }
}
