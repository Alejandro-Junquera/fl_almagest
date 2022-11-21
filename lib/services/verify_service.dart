import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';

class VerifyService extends ChangeNotifier {
  final String _baseUrl = 'salesin.allsites.es';
  final storage = const FlutterSecureStorage();

  isVerify(String id ) async {

    String? token = await AuthService().readToken();

    final url = Uri.http(_baseUrl, '/public/api/confirm', {'user_id': id});
    final resp = await http.post(url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
  }
  static void verifyService(id) {}
}