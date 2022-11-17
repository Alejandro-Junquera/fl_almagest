
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class RegisterService extends ChangeNotifier {
  final String _baseUrl = 'salesin.allsites.es';
  final storage = const FlutterSecureStorage();

  Future<String?> register( String name, String surname, String email, String password,
  String c_password, int cicle_id ) async {
      final Map<String, dynamic> authData = {
        'name': name,
        'surname': surname,
        'email': email,
        'password': password,
        'c_password': c_password,
        'cicle_id': cicle_id,
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
        // Token hay que guardarlo en un lugar seguro
        // decodedResp['idToken'];
        await storage.write(key: 'token', value: decodedResp['data']['token']);
        await storage.write(
            key: 'name', value: decodedResp['data']['name'].toString());
      } else {
        return decodedResp['message'];
      }

      // final resp = await http.post(url, body: json.encode(authData));
      // final Map<String, dynamic> decodedResp = json.decode(resp.body);

      // if (decodedResp.containsKey('idToken')) {
      //   // Token hay que guardarlo en un lugar seguro
      //   await storage.write(key: 'token', value: decodedResp['idToken']);
      //   // decodedResp['idToken'];
      //   return null;
      // } else {
      //   return decodedResp['error']['message'];
      // }
    }

    /*final Map<String, dynamic> duplicateRegister = json.decode(resp.body);
      if (duplicateRegister.containsValue(true)) {
        duplicateRegister.forEach((key, value) {
          if (key == 'data') {
            storage.write(key: 'token', value: value['token']);
          }
        });
      } else {
        String? error = '';

        error = 'Error to register. The email is already taken';

        resp1 = error;
      }
      return resp1;
    }*/
    
}