import 'dart:convert';

import 'package:fl_almagest/services/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ActivateService extends ChangeNotifier {
  String mensaje ='';
   final String _baseUrl = 'salesin.allsites.es';

  Future<String> activate (String userId) async{
      final url = Uri.http(_baseUrl, '/public/api/activate',{'user_id': userId});
      String? token = await AuthService().readToken();
      
      final resp = await http.post(url,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      final Map<String, dynamic> decodedResp = json.decode(resp.body);
      mensaje= decodedResp['message'];
      return decodedResp['message'];
    }
}