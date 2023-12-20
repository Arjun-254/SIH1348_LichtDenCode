import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sih/screens/bottomBar/Queries/AudioInput.dart';
import 'Chat/TextInput.dart';
import 'OCRInput.dart';

class Queries extends StatefulWidget {
  const Queries({Key? key}) : super(key: key);

  @override
  State<Queries> createState() => _QueriesState();
}

class _QueriesState extends State<Queries> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(20),
              child: TabBar(
                tabs: [
                  Tab(
                      icon: const FaIcon(FontAwesomeIcons.cameraRetro, size: 18,),
                      text: AppLocalizations.of(context)!.camera),
                  Tab(
                      icon: const Icon(FontAwesomeIcons.microphone),
                      text: AppLocalizations.of(context)!.audio),
                  Tab(
                      icon: const Icon(FontAwesomeIcons.t),
                      text: AppLocalizations.of(context)!.text),
                ],
                labelStyle: TextStyle(
                  fontFamily: "productSansReg",
                  color: Colors.cyan[500],
                  fontWeight: FontWeight.w500,
                ),
                indicatorColor: Colors.cyan[500],
                dividerColor: Colors.transparent,
              ),
            ),
          ),
          body: const Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    OCRInput(),
                    AudioInput(),
                    TextInput(),
                  ],
                ),
              ),
            ],
          ),
        ));
    ;
  }
}
