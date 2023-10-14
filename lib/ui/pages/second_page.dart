import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text("Second Page"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Second Page'),
      ),
    );
  }
}
