import 'package:sih/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sih/screens/robot.dart';

class SelectLanguageDropdown extends StatefulWidget {
  const SelectLanguageDropdown({super.key});

  @override
  State<SelectLanguageDropdown> createState() => _SelectLanguageDropdownState();
}

class _SelectLanguageDropdownState extends State<SelectLanguageDropdown> {
  String selectedVal = 'en';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(children: [
      DropdownButton(
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
          DropdownMenuItem(value: 'fr', child: Text('Française')),
          DropdownMenuItem(value: 'ar', child: Text('عربي')),
          DropdownMenuItem(value: 'pa', child: Text('فارسی')),
        ],
      ),
      ElevatedButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const Robot()));
          },
          child: const Text("Hi"))
    ])));
  }
}
