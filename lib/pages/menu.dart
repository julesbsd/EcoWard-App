import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ecoward/controllers/providers/PageProvider.dart';
import 'package:ecoward/controllers/providers/UserProvider.dart';
import 'package:ecoward/global/routes.dart';
import 'package:ecoward/pages/account_page.dart';
import 'package:ecoward/pages/action_page.dart';
import 'package:ecoward/pages/challenge_page.dart';
import 'package:ecoward/pages/home_page.dart';
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

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const ChallengePage(),
    const ActionPage(),
    const ChallengePage(),
    const ChallengePage(),
    const ChallengePage(),
  ];

  final List<String> pages = [
    'Home',
    'Actions',
    'Action',
    'Boutique ',
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
        body: Padding(
          padding: const EdgeInsets.all(0),
          child: SingleChildScrollView(
            // Ajout de SingleChildScrollView pour rendre la page défilable
            child: Column(
              children: [
                pPage.getIndex() == 0 || pPage.getIndex() == 2
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: 90,
                        padding: const EdgeInsets.only(
                            top: 40, left: 16, right: 16, bottom: 10),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(0, 230, 118, 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              'Bonjour, ${pUser.user.name}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                            )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  size: 35,
                                  Icons.notifications,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 15),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AccountPage()),
                                      );
                                    },
                                    child: ClipOval(
                                      child: Image.network(
                                        image.isNotEmpty
                                            ? image
                                            : '$serverImgUrl${pUser.user.profile_photo_url}',
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.account_circle,
                                            size: 40,
                                            color: Colors.grey,
                                          );
                                        },
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: 90,
                        padding: const EdgeInsets.only(
                            top: 40, left: 16, right: 16, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                pages[pPage.getIndex()],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  size: 35,
                                  Icons.notifications,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 15),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AccountPage()),
                                      );
                                    },
                                    child: ClipOval(
                                      child: Image.network(
                                        image.isNotEmpty
                                            ? image
                                            : '$serverImgUrl${pUser.user.profile_photo_url}',
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.account_circle,
                                            size: 40,
                                            color: Colors.grey,
                                          );
                                        },
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
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
            Icon(Icons.shopping_cart,
                size: 30,
                color: pPage.getIndex() == 3
                    ? const Color.fromRGBO(0, 230, 118, 1)
                    : Colors.black),
            Icon(Icons.emoji_events,
                size: 30,
                color: pPage.getIndex() == 4
                    ? const Color.fromRGBO(0, 230, 118, 1)
                    : Colors.black),
          ],
          color: const Color.fromRGBO(0, 230, 118, 1),
          buttonBackgroundColor: Colors.black,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 200),
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
