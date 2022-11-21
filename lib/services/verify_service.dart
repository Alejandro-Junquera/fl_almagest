import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';

class VerifyService extends ChangeNotifier {
  final String _baseUrl = 'salesin.allsites.es';
  final storage = const FlutterSecureStorage();

   Future<bool?> isVerify() async {
    
    var id = await storage.read(key: 'id') ?? '';
    final Map<String, dynamic> userId = {
      'user_id': id,
    };
    String? token = await AuthService().readToken();

    final url = Uri.http(_baseUrl, '/public/api/confirm', {});
    final resp = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(userId));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    return decodedResp['success'];
  }
}