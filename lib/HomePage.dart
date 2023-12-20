import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sih/language/changeLanguageDropdown.dart';
import 'package:sih/screens/UserPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
      future: getFlagValuesSF(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData){
          return const SelectLanguageDropdown();
        }
        else if (snapshot.hasData && snapshot.data!){
          return const UserPage();
        }
        else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

Future<bool?> getFlagValuesSF() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstInstall = prefs.getBool('isFirstInstall');
    return isFirstInstall;
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
  return null;
}
