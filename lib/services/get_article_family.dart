import 'dart:convert';
import 'package:fl_almagest/models/articles.dart';
import 'package:fl_almagest/models/articles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GetArticleFamilyService extends ChangeNotifier {
  final String _baseUrl = 'semillero.allsites.es';
  final storage = const FlutterSecureStorage();
  final List<DataArticle> articles = [];
  bool isLoading = true;

  getArticles(String id) async {
    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/public/api/mostrarArt');
    final resp = await http.post(url);
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    var p = Articles.fromJson(decodedResp);
    for (var i in p.data!) {
      if (i.deleted == 0) {
        articles.add(i);
      }
    }
    isLoading = false;
    notifyListeners();
  }
}
