import 'package:flutter/material.dart';
import 'package:fl_almagest/screens/listview_users_screen.dart';
class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListviewUsersScreen(),
    );
  }
}
