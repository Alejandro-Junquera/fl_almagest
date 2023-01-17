import 'dart:convert';

import 'package:fl_almagest/models/oders.dart';
import 'package:fl_almagest/services/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrdersService extends ChangeNotifier {
  final String _baseUrl = 'semillero.allsites.es';
  bool isLoading = true;
  final List<DataOrders> orders = [];
  OrdersService() {
    getOrders();
  }

  Future<List<DataOrders>> getOrders() async {
    final url = Uri.http(_baseUrl, '/public/api/orders');
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
    var order = Orders.fromJson(decodedResp);
    for (var i in order.data!) {
      orders.add(i);
    }
    isLoading = false;
    notifyListeners();
    return orders;
  }
}
