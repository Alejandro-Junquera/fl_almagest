import 'dart:convert';

import 'package:fl_almagest/models/userAlone.dart';
import 'package:fl_almagest/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:fl_almagest/models/models.dart';

class UserAloneService extends ChangeNotifier {
  final String _baseUrl = 'semillero.allsites.es';
  bool isLoading = true;
  UserAlone user = UserAlone();

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
    var usuario = UserAlone.fromJson(decodedResp);
    user = usuario.data! as UserAlone;
    print(decodedResp);
    isLoading = false;
    notifyListeners();
    return decodedResp['data']['deleted'];
  }
}
