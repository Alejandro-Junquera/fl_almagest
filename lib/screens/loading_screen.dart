import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading'),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
          child: CircularProgressIndicator(
        color: Color.fromARGB(255, 153, 8, 0),
      )),
    );
  }
}
