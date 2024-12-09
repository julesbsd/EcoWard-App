import 'dart:developer';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ecoward/components/drawer.dart';
import 'package:ecoward/controllers/providers/PageProvider.dart';
import 'package:ecoward/controllers/providers/UserProvider.dart';
import 'package:ecoward/global/routes.dart';
import 'package:ecoward/pages/action_page.dart';
import 'package:ecoward/pages/calendar_page.dart';
import 'package:ecoward/pages/challenge_page.dart';
import 'package:ecoward/pages/graphic_page.dart';
import 'package:ecoward/pages/home_page.dart';
import 'package:ecoward/pages/ranking_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String image = '';
  late UserProvider pUser;
  late Pageprovider pPage;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const ChallengePage(),
    const ActionPage(),
    RankingPage(),
    CalendarPage(),
      ];

  final List<String> pages = [
    'Home',
    'Défi',
    'Action',
    'Classement ',
    'Statistiques',
  ];

  @override
  void initState() {
    super.initState();
    pUser = Provider.of<UserProvider>(context, listen: false);
    pPage = Provider.of<Pageprovider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: Container(),
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
          title: Text(
            pages[pPage.getIndex()],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          ),
          actions: [
            IconButton(
              onPressed: () {
          // Navigator.pushNamed(context, Routes.notification);
              },
              icon: const Icon(
          Icons.notifications,
          color: Colors.black,
              ),
            ),
            GestureDetector(
              onTap: () {
          scaffoldKey.currentState?.openDrawer();
              },
              child: Padding(
          padding: const EdgeInsets.only(right: 10.0), // Add padding to the right
          child: ClipOval(
            child: Image.network(
              image.isNotEmpty
            ? image
            : '$serverImgUrl${pUser.user.profile_photo_url}',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
            Icons.account_circle,
            size: 40,
            color: Colors.grey,
                );
              },
            ),
          ),
              ),
            ),
          ],
        ),
        drawer: DrawerComponent.buildMenuDrawer(context),
        body: Padding(
          padding: const EdgeInsets.all(0),
          child: SingleChildScrollView(
            // Ajout de SingleChildScrollView pour rendre la page défilable
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 50,
                  child: _widgetOptions[pPage.getIndex()],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          height: 60,
          key: _bottomNavigationKey,
          index: pPage.getIndex(),
          items: <Widget>[
            Icon(Icons.home,
                size: 30,
                color: pPage.getIndex() == 0
                    ? const Color.fromRGBO(0, 230, 118, 1)
                    : Colors.black),
            Icon(Icons.bolt,
                size: 30,
                color: pPage.getIndex() == 1
                    ? const Color.fromRGBO(0, 230, 118, 1)
                    : Colors.black),
            Icon(Icons.add,
                size: 30,
                color: pPage.getIndex() == 2
                    ? const Color.fromRGBO(0, 230, 118, 1)
                    : Colors.black),
            Icon(Icons.emoji_events,
                size: 30,
                color: pPage.getIndex() == 3
                    ? const Color.fromRGBO(0, 230, 118, 1)
                    : Colors.black),
            Icon(Icons.person,
                size: 30,
                color: pPage.getIndex() == 4
                    ? const Color.fromRGBO(0, 230, 118, 1)
                    : Colors.black),
          ],
          color: const Color.fromRGBO(0, 230, 118, 1),
          buttonBackgroundColor: Colors.black,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 150),
          onTap: (selectedIndex) {
            setState(() {
              pPage.setIndex(selectedIndex);
            });
          },
          letIndexChange: (index) => true,
        ),
      ),
    );
  }
}
