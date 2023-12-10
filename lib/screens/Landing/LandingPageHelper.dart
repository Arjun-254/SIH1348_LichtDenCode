import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LandingPage1 extends StatefulWidget {
  const LandingPage1({Key? key}) : super(key: key);

  @override
  State<LandingPage1> createState() => _LandingPage1State();
}

class _LandingPage1State extends State<LandingPage1> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Lottie.asset("assets/landing1.json",
                  width: width * (400 / 340), height: height * (400 / 804)),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  AppLocalizations.of(context)!.landingPageOne,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan[500],
                      fontFamily: "productSansReg"),
                ),
              )
            ]),
      ),
    );
  }
}

class LandingPage2 extends StatefulWidget {
  const LandingPage2({Key? key}) : super(key: key);

  @override
  State<LandingPage2> createState() => _LandingPage2State();
}

class _LandingPage2State extends State<LandingPage2> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Lottie.asset("assets/landing2.json",
                  width: width * (400 / 340), height: height * (400 / 804)),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  AppLocalizations.of(context)!.landingPageTwo,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan[500],
                      fontFamily: "productSansReg"),
                ),
              )
            ]),
      ),
    );
  }
}

class LandingPage3 extends StatefulWidget {
  const LandingPage3({Key? key}) : super(key: key);

  @override
  State<LandingPage3> createState() => _LandingPage3State();
}

class _LandingPage3State extends State<LandingPage3> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Lottie.asset("assets/landing3.json",
                  width: width * (400 / 340), height: height * (400 / 804)),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  AppLocalizations.of(context)!.landingPageThree,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan[500],
                      fontFamily: "productSansReg"),
                ),
              )
            ]),
      ),
    );
  }
}
