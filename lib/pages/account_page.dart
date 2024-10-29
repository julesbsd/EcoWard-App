import 'dart:developer';

import 'package:ecoward/controllers/login_or_register.dart';
import 'package:ecoward/controllers/persistance_handler.dart';
import 'package:ecoward/controllers/providers/UserProvider.dart';
import 'package:ecoward/global/routes.dart';
import 'package:ecoward/http/http_service.dart';
import 'package:ecoward/pages/friends_page.dart';
import 'package:ecoward/pages/menu.dart';
import 'package:ecoward/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late UserProvider pUser;

  @override
  void initState() {
    super.initState();
    pUser = Provider.of<UserProvider>(context, listen: false);
  }

  Future<void> _logout(BuildContext context) async {
    try {
      String token = await PersistanceHandler().getAccessToken();
      // String body = await JSONHandler().logout(token);

      Response res = await HttpService().makeGetRequestWithToken(getLogout);

      if (res.statusCode == 200) {
        await PersistanceHandler().delAccessToken();
        await PersistanceHandler().delUser();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginOrRegister()),
        );
      } else {
        if (res.statusCode == 401) {
          await PersistanceHandler().delAccessToken();
          await PersistanceHandler().delUser();
          print('logout sctatus code: ${res.statusCode}');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginOrRegister()),
          );
          // Token is not valid, already handled in logoutService
          // Navigator.pushReplacementNamed(context, '/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to logout: ${res.body}')),
          );
        }
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Mon compte'),
      //   backgroundColor: Color.fromRGBO(0, 230, 118, 1),
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(builder: (context) => Menu()),
      //       );
      //     },
      //   ),
      // ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person, color: Colors.black, size: 30),
            title: Text('Mon profil',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 18)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.group, color: Colors.black, size: 30),
            title: Text('Mes amis',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 18)),
            onTap: () {
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => FriendsPage()),
              // );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FriendsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.history, color: Colors.black, size: 30),
            title: Text('Mon historique des actions',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 18)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart, color: Colors.black, size: 30),
            title: Text('Mes commandes',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 18)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.eco, color: Colors.black, size: 30),
            title: Text('Découvrir la vie des déchets',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 18)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.star, color: Colors.black, size: 30),
            title: Text('Noter l\'application',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 18)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.business, color: Colors.black, size: 30),
            title: Text('Nos partenaires',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 18)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.replay, color: Colors.black, size: 30),
            title: Text('Revoir le tutoriel',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 18)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.help, color: Colors.black, size: 30),
            title: Text('Aide et mentions',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 18)),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.black, size: 30),
            title: Text('Se déconnecter',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 18)),
            onTap: () {
              _logout(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.red, size: 30),
            title: Text(
              'Supprimer mon compte',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: 18, color: Colors.red),
            ),
            onTap: () {
              // Ajoutez votre logique de suppression de compte ici
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Text(
                'v1.1 - Production',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
