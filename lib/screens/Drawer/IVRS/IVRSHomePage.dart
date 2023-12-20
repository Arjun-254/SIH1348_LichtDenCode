import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sih/screens/Drawer/IVRS/IVRS.dart';
import 'package:sih/auth/Login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IVRSHomePage extends StatefulWidget {
  const IVRSHomePage({Key? key}) : super(key: key);

  @override
  State<IVRSHomePage> createState() => _IVRSHomePageState();
}

class _IVRSHomePageState extends State<IVRSHomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getIVRSFlagValuesSF(),
      builder: (context, snapshot) {
        print(snapshot.data);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData && snapshot.data![0] == null) {
          return const Login();
        } else if (snapshot.hasData) {
          print(snapshot.data);
          if (snapshot.data![0]) {
            return IVRS(
              token: snapshot.data![1],
            );
          } else {
            return const Login();
          }
        } else if (snapshot.hasError) {
          if (kDebugMode) {
            print(snapshot.error);
          }
          return const Center(
            child: Text("Error occurred"),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

Future<List<dynamic>?> getIVRSFlagValuesSF() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    bool? isLoggedIn = prefs.getBool('isLoggedIn');
    return [isLoggedIn, token];
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
  return null;
}
