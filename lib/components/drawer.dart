import 'package:ecoward/pages/calendar_page.dart';
import 'package:ecoward/pages/friends_page.dart';
import 'package:ecoward/pages/graphic_page.dart';
import 'package:ecoward/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'package:ecoward/http/http_service.dart';
import 'package:ecoward/global/routes.dart';
import 'package:ecoward/controllers/providers/UserProvider.dart';
import 'package:ecoward/controllers/persistance_handler.dart';
import 'package:ecoward/controllers/login_or_register.dart';

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

class DrawerComponent {
  static Widget buildMenuDrawer(BuildContext context) {
    return SizedBox(
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: ListView(
            children: [
              DrawerHeader(
                child: Image.asset(
                  'lib/assets/ecoward_logo.png',
                  width: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          offset: Offset(4, 4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-4, -4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: Icon(Icons.person,
                          color: Theme.of(context).colorScheme.primary,
                          size: 30),
                    ),
                  ),
                  title: Text(
                    'Mon profil',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          offset: Offset(4, 4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-4, -4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: Icon(Icons.analytics,
                          color: Theme.of(context).colorScheme.primary,
                          size: 30),
                    ),
                  ),
                  title: Text('Statistiques',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 18)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CalendarPage()),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          offset: Offset(4, 4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-4, -4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: Icon(Icons.star,
                          color: Theme.of(context).colorScheme.primary,
                          size: 30),
                    ),
                  ),
                  title: Text('Noter l\'application',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 18)),
                  onTap: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          offset: Offset(4, 4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-4, -4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: Icon(Icons.business,
                          color: Theme.of(context).colorScheme.primary,
                          size: 30),
                    ),
                  ),
                  title: Text('Nos partenaires',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 18)),
                  onTap: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          offset: Offset(4, 4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-4, -4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: Icon(Icons.replay,
                          color: Theme.of(context).colorScheme.primary,
                          size: 30),
                    ),
                  ),
                  title: Text('Revoir le tutoriel',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 18)),
                  onTap: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          offset: Offset(4, 4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-4, -4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: Icon(Icons.help,
                          color: Theme.of(context).colorScheme.primary,
                          size: 30),
                    ),
                  ),
                  title: Text('Aide et mentions',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 18)),
                  onTap: () {},
                ),
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
              Divider(),
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
        ),
      ),
    );
  }

  static Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.grey,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }

  static Widget _buildDivider() {
    return const Divider(
      height: 10,
      color: Colors.blueGrey,
      thickness: 1,
      indent: 10,
      endIndent: 10,
    );
  }
}
