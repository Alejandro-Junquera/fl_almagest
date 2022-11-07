import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'salesin.allsites.es';

  Future<String?> createUser(String name, String surname, String email,
      String password, String c_password, String cicle_id) async {
    final Map<String, dynamic> authData = {
      'name': name,
      'surname': surname,
      'email': email,
      'password': password,
      'c_password': c_password,
      'cicle_id': cicle_id
    };
    final url = Uri.http(_baseUrl, '/public/api/register');
    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
  }

  Future<String?> login(String email, String password) async {
    /*
    try {
      final Map<String, dynamic> body = {'email': email, 'password': password};
      var url = Uri.parse("http://salesin.allsites.es/public/api/login");
      var respuesta = http.post(url, body: json.encode(body),
      });
      respuesta.then((value) => print(value.body.toString()));
    } catch (e) {
      print(e);
    }
    */

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url = Uri.http(_baseUrl, '/public/api/login', {});
    final resp = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Some token"
        },
        body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    if (decodedResp['success'] == true) {
      print(decodedResp);
    }
  }
}
