import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fl_almagest/models/userAlone.dart';
import 'package:fl_almagest/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:fl_almagest/models/models.dart';

class UserAloneService extends ChangeNotifier {
  final String _baseUrl = 'semillero.allsites.es';
  final storage = const FlutterSecureStorage();
  bool isLoading = true;

  readUserAlone() async {
    String? token = await AuthService().readToken();
    String? id = await AuthService().readId();
    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/public/api/user/$id');
    final resp = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": 'Bearer $token',
      },
    );
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
    var usuario = UserAlone.fromJson(decodedResp);
    await storage.write(
        key: 'company_id', value: decodedResp['data']['company_id'].toString());
    isLoading = false;
    notifyListeners();
    return decodedResp['company_id'];
  }

  readCompany_id() async {
    return await storage.read(key: 'company_id') ?? '';
  }
}
