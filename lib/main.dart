import 'package:flutter/material.dart';
import 'package:sih/screens/HomePage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
     const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
}