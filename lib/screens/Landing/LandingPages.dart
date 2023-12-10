import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:sih/HomePage.dart';
import 'LandingPageHelper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: OnBoardingSlider(
        pageBackgroundGradient: LinearGradient(colors: [
          Colors.grey[900]!,
          Colors.black,
          Colors.grey[900]!,
        ]),
        controllerColor: Colors.cyan[500],
        headerBackgroundColor: Colors.black,
        finishButtonText: AppLocalizations.of(context)!.getStarted,
        finishButtonStyle: FinishButtonStyle(
            backgroundColor: Colors.cyan[500],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.0),
            )),
        onFinish: () {
          Navigator.of(context).pop();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const HomePage()));
        },
        skipTextButton: Text(
          AppLocalizations.of(context)!.skip,
          style:
              TextStyle(color: Colors.cyan[500], fontFamily: "productSansReg"),
        ),
        background: const [SizedBox(), SizedBox(), SizedBox()],
        pageBodies: const [LandingPage1(), LandingPage2(), LandingPage3()],
        totalPage: 3,
        speed: 1.8,
      ),
    );
  }
}
