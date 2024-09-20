import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ecoward/controllers/providers/UserProvider.dart';
import 'package:ecoward/model/user.dart';
import 'package:ecoward/widget/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _page = 0;

  late UserProvider pUser;


  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  void _onItemTapped(int index) {
    setState(() {
      _page = index;
    });
  }

@override
  void initState() {
    super.initState();
    pUser = Provider.of<UserProvider>(context, listen: false);
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
                HeaderWidget(
                    username: pUser.getUser.name,
                    points: 30,
                    profilePhotoUrl: pUser.getUser.profilePhotoUrl),
                // const CarouselWidget(),
                // if (user == null)
                const Center(
                    child:
                        CircularProgressIndicator()), // Indicateur de chargement

                // Ajoutez le reste de votre contenu ici
                // Exemple :
                // SizedBox(height: 20),
                Container(
                  // height: 200,
                  child: Image.asset(
                    'lib/assets/homePage1.png',
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                // SizedBox(height: 20),
                // ShopWidget(),
                const Text('Contenu supplémentaire 2'),
                // Ajoutez autant de contenu que nécessaire pour tester le défilement
              ],
            ),
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          height: 60,
          key: _bottomNavigationKey,
          index: 0,
          items: <Widget>[
            Icon(Icons.home,
                size: 30,
                color: _page == 0
                    ? const Color.fromRGBO(0, 230, 118, 1)
                    : Colors.black),
            Icon(Icons.bolt,
                size: 30,
                color: _page == 1
                    ? const Color.fromRGBO(0, 230, 118, 1)
                    : Colors.black),
            Icon(Icons.add,
                size: 30,
                color: _page == 2
                    ? const Color.fromRGBO(0, 230, 118, 1)
                    : Colors.black),
            Icon(Icons.shopping_cart,
                size: 30,
                color: _page == 3
                    ? const Color.fromRGBO(0, 230, 118, 1)
                    : Colors.black),
            Icon(Icons.emoji_events,
                size: 30,
                color: _page == 4
                    ? const Color.fromRGBO(0, 230, 118, 1)
                    : Colors.black),
          ],
          color: const Color.fromRGBO(0, 230, 118, 1),
          buttonBackgroundColor: Colors.black,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 200),
          onTap: _onItemTapped,
          letIndexChange: (index) => true,
        ),
      ),
    );
  }
}
