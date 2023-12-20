import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:sih/screens/robot.dart';
import '../constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChooseLanguage extends StatefulWidget {
  const ChooseLanguage({super.key});

  @override
  State<ChooseLanguage> createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {
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
              colors: [
                Colors.grey[900]!,
                Colors.black,
                Colors.grey[900]!,
              ]),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 50 * (height / deviceHeight),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)!.meetAtom,
                    style: const TextStyle(
                        fontFamily: "productSansReg",
                        color: Color(0xFF009CFF),
                        fontWeight: FontWeight.w700,
                        fontSize: 30),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)!.aiPoweredAsst,
                    style: const TextStyle(
                        fontFamily: "productSansReg",
                        color: Color(0xFF009CFF),
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 500 * (height / deviceHeight),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ModelViewer(
                      backgroundColor: Colors.transparent,
                      src: 'assets/output_model.gltf',
                      alt: 'A 3D model of an astronaut',
                      autoRotate: true,
                      disableZoom: true,
                      autoPlay: true,
                    ),
                  ),
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
                          gradient: LinearGradient(
                              colors: [Colors.blue[700]!, Colors.blue[500]!]),
                          borderRadius: BorderRadius.circular(25)),
                      child: Container(
                        width: 165 * (height / deviceHeight),
                        height: 60 * (height / deviceHeight),
                        alignment: Alignment.center,
                        child: Text(
                          AppLocalizations.of(context)!.tryItOut,
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
              ],
            ),
          ),
        ),
      ),
    );
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
