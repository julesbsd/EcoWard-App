import 'dart:developer';

import 'package:ecoward/components/my_button.dart';
import 'package:ecoward/controllers/persistance_handler.dart';
import 'package:ecoward/controllers/providers/UserProvider.dart';
import 'package:ecoward/global/routes.dart';
import 'package:ecoward/http/http_service.dart';
import 'package:ecoward/model/user.dart';
import 'package:ecoward/pages/forgot_password.dart';
import 'package:ecoward/pages/menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:ecoward/controllers/json_handler.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late UserProvider pUser;

  final TextEditingController emailController =
      TextEditingController(text: 'stan43@example.com');

  final TextEditingController passwordController =
      TextEditingController(text: 'password');

  @override
  void initState() {
    super.initState();
    pUser = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 80),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[100],
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow,
                        offset: const Offset(7.0, 7.0),
                        blurRadius: 10,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(
                          25.0), // Ajuster le padding si nécessaire
                      child: Image.asset(
                        'lib/assets/ecoward_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60.0),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow,
                        offset: const Offset(8.0, 8.0),
                        blurRadius: 8,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'username@gmail.com',
                      hintStyle: Theme.of(context).textTheme.displayLarge,
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                    ),
                    obscureText: false,
                  ),
                ),
                const SizedBox(height: 25.0),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow,
                        offset: const Offset(8.0, 8.0),
                        blurRadius: 8,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Mot de passe',
                      hintStyle: Theme.of(context).textTheme.displayLarge,
                      prefixIcon: const Icon(Icons.lock_outlined),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 30.0),
                MyButton(
                    text: 'Connexion',
                    textColor: Colors.white,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    onTap: () async {
                      String body = await JSONHandler()
                          .login(emailController.text, passwordController.text);

                      Response res = await HttpService()
                          .makePostRequestWithoutToken(postLogin, body);

                      if (res.statusCode == 200) {
                        final Map<String, dynamic> responseData =
                            jsonDecode(res.body);

                        final String token = responseData['access_token'];

                        final Map<String, dynamic> userData =
                            responseData['user'];

                        final String image =
                            responseData['profile_photo_url'] ?? '';

                        User user = User.fromJson(userData);

                        await PersistanceHandler().setAccessToken(token);
                        await PersistanceHandler().profilePhoto(image);
                        pUser.setUser(user);

                        // Vérifier les données sauvegardées
                        var getToken =
                            await PersistanceHandler().getAccessToken();
                        User? getUser = await PersistanceHandler().getUser();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Menu(),
                          ),
                        );
                      } else {
                        final Map<String, dynamic> responseData =
                            jsonDecode(res.body);

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Erreur de connexion'),
                              content: responseData['error'] is Map
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: (responseData['error']
                                              as Map<String, dynamic>)
                                          .values
                                          .expand((element) => element)
                                          .map((e) => Text(e))
                                          .toList(),
                                    )
                                  : Text(responseData['error'].toString()),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Inscription',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontFamily: 'Raleway',
                            fontSize: 16),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPassword(),
                          ),
                        );
                      },
                      child: Text(
                        'Mot de passe oublié ?',
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
