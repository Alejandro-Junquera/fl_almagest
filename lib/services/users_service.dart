import 'dart:convert';
import 'package:fl_almagest/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:fl_almagest/models/models.dart';

class UserService extends ChangeNotifier {
  final String _baseUrl = 'salesin.allsites.es';
  bool isLoading = true;
  final List<DataUsers> usuarios = [];

  UserService() {
    getUsers();
  }
  Future<List<DataUsers>> getUsers() async {
    final url = Uri.http(_baseUrl, '/public/api/users');
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
    var user= Users.fromJson(decodedResp);
    for(var i in user.data!){
      usuarios.add(i);
    }
    // decodedResp.forEach((key, value) {
    //   if (key == 'data') {
    //     List<dynamic> userD = value;
    //     for (int i = 0; i < userD.length; i++) {
    //       final valueUser = DataUsers.fromJson(userD[i]);
    //       usuarios.add(valueUser);
    //     }
    //   }
     
    // });
    isLoading = false;
    notifyListeners();
    return usuarios;
  }
}
