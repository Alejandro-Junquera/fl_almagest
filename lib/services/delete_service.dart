import 'dart:convert';
import 'package:fl_almagest/services/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteService extends ChangeNotifier {
  String mensaje = '';
  final String _baseUrl = 'semillero.allsites.es';

  Future<String> delete(String userId) async {
    print(userId);
    final url =
        Uri.http(_baseUrl, '/public/api/user/deleted', {'user_id': userId});
    String? token = await AuthService().readToken();

    final resp = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
    mensaje = decodedResp['message'];
    return decodedResp['message'];
  }
}
