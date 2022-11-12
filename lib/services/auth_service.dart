import 'dart:convert';
import 'package:fl_almagest/models/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  //Esta list es la que llama desde adminScreen
  final String _baseUrl = 'salesin.allsites.es';
  final storage = const FlutterSecureStorage();
  bool isLoading = true;
  List<Data> ciclos = [];
  
  readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
  //usuario: confirmado@gmail.com
  //registrado@gmail.com
  //activado@gmail.com
  //password: 12345678

  Future<String?> login(String email, String password) async {
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
      await storage.write(key: 'token', value: decodedResp['data']['token']);
      await storage.write(
          key: 'id', value: decodedResp['data']['id'].toString());
      return decodedResp['data']['type'] +
          ',' +
          decodedResp['data']['actived'].toString();
    } else {
      return decodedResp['message'];
    }
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
  }

Future<List<Data>> getCicles() async {
    final url = Uri.http(_baseUrl, '/public/api/cicles');
    String? token = await AuthService().readToken();
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
    return ciclos;
  }

  Future<bool?> isVerify() async {
    var id = await storage.read(key: 'id') as String;
    final Map<String, dynamic> user_id = {
      'user_id': int.parse(id),
    };
    var token = await storage.read(key: 'token') as String;
    final url = Uri.http(_baseUrl, '/public/api/confirm', {});
    final resp = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(user_id));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    return decodedResp['success'];
  }

  Future logout() async{
    await storage.delete(key: 'token');
    return;
  }
}
