import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
     backgroundColor:Color.fromRGBO(63, 63, 156, 1),
      body: Center(
        child: CircularProgressIndicator(
        color: Colors.white
        )
      ),
    );
  }
}

