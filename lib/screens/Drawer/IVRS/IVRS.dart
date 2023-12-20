import 'package:flutter/material.dart';

class IVRS extends StatefulWidget {
  const IVRS({Key? key, required this.token}) : super(key: key);
  final String token;

  @override
  State<IVRS> createState() => _IVRSState();
}

class _IVRSState extends State<IVRS> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Women Safety Page"),
      ),
      body: const Center(
        child: Text("Safety Page"),
      ),
    ));
  }
}
