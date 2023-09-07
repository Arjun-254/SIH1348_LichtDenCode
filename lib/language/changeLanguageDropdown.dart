import 'package:lottie/lottie.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:sih/main.dart';
import 'package:flutter/material.dart';
import 'package:sih/screens/robot.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants.dart';

class SelectLanguageDropdown extends StatefulWidget {
  const SelectLanguageDropdown({super.key});

  @override
  State<SelectLanguageDropdown> createState() => _SelectLanguageDropdownState();
}

class _SelectLanguageDropdownState extends State<SelectLanguageDropdown> {
  String selectedVal = 'en';
  double deviceHeight = Constants().deviceHeight,
      deviceWidth = Constants().deviceWidth;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.blue[200]!, Colors.cyan[300]!]),
            ),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Column(children: [
                    SizedBox(
                      height: 100 * (height / deviceHeight),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context)!.chooseLanguage,
                        style: const TextStyle(
                            fontFamily: "productSansReg",
                            color: Color(0xFF009CFF),
                            fontWeight: FontWeight.w700,
                            fontSize: 30),
                      ),
                    ),
                    SizedBox(
                      height: 20 * (height / deviceHeight),
                    ),
                    Lottie.asset(
                      'assets/languageTranslate.json',
                      width: 250 * (height / deviceHeight),
                      height: 250 * (height / deviceHeight),
                      fit: BoxFit.contain,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: DropdownButtonFormField(
                        onChanged: (v) => setState(() {
                          MainApp.setLocale(context, Locale(v.toString()));
                          selectedVal = v!;
                        }),
                        value: selectedVal,
                        items: const [
                          DropdownMenuItem(
                            value: 'en',
                            child: Text('English'),
                          ),
                          DropdownMenuItem(value: 'hi', child: Text('हिंदी')),
                          DropdownMenuItem(value: 'mr', child: Text('मराठी')),
                          DropdownMenuItem(
                              value: 'fr', child: Text('Française')),
                          DropdownMenuItem(value: 'ar', child: Text('عربي')),
                          DropdownMenuItem(value: 'pa', child: Text('فارسی')),
                        ],
                        style: const TextStyle(
                            fontFamily: "productSansReg",
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(13),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide.none)),
                      ),
                    ),
                    SizedBox(
                      height: 20 * (height / deviceHeight),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(_createRoute());
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60))),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colors.blue[700]!,
                                Colors.blue[500]!
                              ]),
                              borderRadius: BorderRadius.circular(25)),
                          child: Container(
                            width: 165 * (height / deviceHeight),
                            height: 60 * (height / deviceHeight),
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!.proceed,
                              style: const TextStyle(
                                  fontFamily: "productSansReg",
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ))));
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Robot(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
