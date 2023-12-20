import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sih/screens/Drawer/Drawer.dart';
import 'package:sih/screens/Profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sih/screens/bottomBar/Dashboard/Dashboard.dart';
import 'package:sih/screens/bottomBar/Queries/Queries.dart';
import 'package:sih/screens/bottomBar/News/NewsPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int currentIndex = 1;
  final screens = const [Dashboard(), Queries(), FlutterNews()];
  bool? isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    getLoginDetails();
  }

  getLoginDetails() async {
    bool? isLoggedIn = await getLoginFlagValuesSF() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        //extendBody: true,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ProfilePage()));
              },
              icon: Image.asset(
                'assets/images/new_profile.png',
                height: height * (42 / 804),
                width: width * (42 / 340),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: IndexedStack(
          index: currentIndex,
          children: screens,
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.cyan[500],
              selectedItemColor: Colors.black,
              selectedFontSize: 18,
              unselectedFontSize: 14,
              iconSize: 27,
              showUnselectedLabels: false,
              currentIndex: currentIndex,
              onTap: (index) => setState(() {
                currentIndex = index;
              }),
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.announcement_outlined,
                      color: Colors.grey[900],
                    ),
                    label: "Announce"),
                BottomNavigationBarItem(
                  icon: FaIcon(
                    Icons.question_answer_outlined,
                    color: Colors.grey[900],
                  ),
                  label: AppLocalizations.of(context)!.qna,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.train_outlined,
                    color: Colors.grey[900],
                  ),
                  label: AppLocalizations.of(context)!.news,
                ),
              ],
            ),
          ),
        ),
        drawer: NavigationDrawer1(isLoggedIn: isLoggedIn!),
      ),
    );
  }
}

Future<bool?> getLoginFlagValuesSF() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');
    return isLoggedIn;
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
  return null;
}
