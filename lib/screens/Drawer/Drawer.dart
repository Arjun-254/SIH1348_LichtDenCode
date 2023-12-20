import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sih/screens/Drawer/IVRS/IVRSHomePage.dart';
import 'Setting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavigationDrawer1 extends StatelessWidget {
  const NavigationDrawer1({Key? key, required this.isLoggedIn})
      : super(key: key);
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blueGrey[100],
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[buildHeader(context), buildMenuItems(context)],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
        padding: const EdgeInsets.only(top: 20.0),
      );

  Widget buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.all(24.0),
      child: Wrap(runSpacing: 16, children: [
        Column(children: <Widget>[
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Colors.black,
              size: 30,
            ),
            title: Text(AppLocalizations.of(context)!.setting,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 20)),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Setting()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.call,
              color: Colors.black,
              size: 30,
            ),
            title: Text(AppLocalizations.of(context)!.ivrs,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 20)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const IVRSHomePage()));
            },
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.redAccent,
                size: 30,
              ),
              title: Text(AppLocalizations.of(context)!.logout,
                  style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w700,
                      fontSize: 20)),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                await prefs.setString('token', '');
              }),
        ]),
      ]));
}
