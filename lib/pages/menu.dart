import 'dart:developer';

import 'package:ecoward/components/drawer.dart';
import 'package:ecoward/controllers/providers/PageProvider.dart';
import 'package:ecoward/controllers/providers/UserProvider.dart';
import 'package:ecoward/global/routes.dart';
import 'package:ecoward/pages/action_page.dart';
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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const ActionPage(),
    RankingPage(),
  ];

  final List<String> pages = [
    'Home',
    'Action',
    'Classement',
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
                padding: const EdgeInsets.only(right: 10.0),
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
        bottomNavigationBar: BottomAppBar(
          color: Colors.grey.shade200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  size: 30,
                  Icons.home,
                  color: pPage.getIndex() == 0
                      ? const Color.fromRGBO(0, 230, 118, 1)
                      : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    pPage.setIndex(0);
                  });
                },
              ),
              const SizedBox(width: 40), // The dummy child for spacing
              IconButton(
                icon: Icon(
                  size: 30,
                  Icons.emoji_events,
                  color: pPage.getIndex() == 2
                      ? const Color.fromRGBO(0, 230, 118, 1)
                      : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    pPage.setIndex(2);
                  });
                },
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              pPage.setIndex(1);
            });
          },
          child: const Icon(Icons.add, size: 40,),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}