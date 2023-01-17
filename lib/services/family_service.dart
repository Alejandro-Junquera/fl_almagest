import 'dart:convert';

import 'package:fl_almagest/models/family.dart';
import 'package:fl_almagest/models/oders.dart';
import 'package:fl_almagest/services/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FamilyService extends ChangeNotifier {
  final String _baseUrl = 'semillero.allsites.es';
  bool isLoading = true;
  final List<DataFamily> families = [];

  Future<List<DataFamily>> getFamilies() async {
    final url = Uri.http(_baseUrl, '/public/api/families');
    isLoading = true;
    notifyListeners();
    String? token = await AuthService().readToken();
    final resp = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token"
      },
    );
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
    var family = Family.fromJson(decodedResp);
    for (var i in family.data!) {
      families.add(i);
    }
    isLoading = false;
    notifyListeners();
    return families;
  }
}
