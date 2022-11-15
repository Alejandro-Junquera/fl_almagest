
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/cicles.dart';

class UserService extends ChangeNotifier {
  final String _baseUrl = 'salesin.allsites.es';
  bool isLoading = true;
  final List<Data> ciclos = [];

Future<List<Data>> getCicles() async {
    final url = Uri.http(_baseUrl, '/public/api/cicles');
    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": " "
      }, 
    );
    final Map<String, dynamic> decodedResp = json.decode(resp.body); 
    var cicle= Cicles.fromJson(decodedResp);
    for(var i in cicle.data!){
      ciclos.add(i);
    }
    isLoading = false;
    notifyListeners();
    return ciclos;
  }
}