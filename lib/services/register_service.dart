
import 'dart:convert';
import 'package:fl_almagest/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'verify_service.dart';
class RegisterService extends ChangeNotifier {
  final String _baseUrl = 'salesin.allsites.es';
  final storage = const FlutterSecureStorage();
  

  Future<String?> register( String name, String surname, String email, String password,
  String cPassword, int cicleId ) async {
      final Map<String, dynamic> authData = {
        'name': name,
        'surname': surname,
        'email': email,
        'password': password,
        'c_password': cPassword,
        'cicle_id': cicleId,
      };
      final url = Uri.http(_baseUrl, '/public/api/register', {});

      final resp = await http.post(url,
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            "Authorization": "Some token"
          },
          body: json.encode(authData));
      final Map<String, dynamic> decodedResp = json.decode(resp.body);

      if (decodedResp['success'] == true) {
        await storage.write(key: 'token', value: decodedResp['data']['token']);
        await storage.write(
            key: 'name', value: decodedResp['data']['name'].toString());
        String id = decodedResp['data']['id'].toString();
        VerifyService().isVerify(id);
      } else {
        return decodedResp['message'];
      }
      return null;
    }    
}