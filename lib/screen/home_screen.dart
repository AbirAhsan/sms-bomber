import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("SMS Bomber"),
      ),
      body: SizedBox(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
