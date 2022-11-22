import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
     backgroundColor:Color.fromARGB(255, 44, 145, 228),
      body: Center(
        child: CircularProgressIndicator(
        color: Colors.white
        )
      ),
    );
  }
}

