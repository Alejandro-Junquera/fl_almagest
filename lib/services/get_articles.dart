import 'dart:convert';
import 'package:fl_almagest/models/catalog.dart';
import 'package:fl_almagest/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:fl_almagest/models/models.dart';

import '../models/articles.dart';
import 'get_products.dart';

class ArticleService extends ChangeNotifier {
  final String _baseUrl = 'semillero.allsites.es';
  bool isLoading = true;
  final List<DataArticle> articles = [];

  getArticles() async {
    final catalogService = CatalogService();
    await catalogService.getCatalog();
    final List<CatalogData> catalog = catalogService.catalogdata;

    articles.clear();
    final url = Uri.http(_baseUrl, '/public/api/articles');
    String? token = await AuthService().readToken();
    isLoading = true;
    notifyListeners();
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
    var article = Articles.fromJson(decodedResp);
    for (var i in article.data!) {
      articles.add(i);
    }
    for (var i in catalog) {
      articles.removeWhere((element) => (element.id == i.articleId));
    }
    isLoading = false;
    notifyListeners();
    return articles;
  }
}
