import 'package:flutter/material.dart';

class DrawerComponent {
  static Widget buildMenuDrawer(BuildContext context) {
    return SizedBox(
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildMenuItem(
                context: context,
                icon: Icons.logout,
                title: "1",
                //Todo demander la logique derière la fin de la livraison euh je croi
                onTap: () => Navigator.of(context).pushReplacementNamed('/'),
              ),
              _buildDivider(),
              _buildMenuItem(
                context: context,
                icon: Icons.power_settings_new,
                title: "2",
                onTap: () => Navigator.of(context).pushReplacementNamed('/'),
              ),
              _buildDivider(),
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