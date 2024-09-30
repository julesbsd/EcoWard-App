import 'dart:convert';
import 'dart:developer';

import 'package:ecoward/controllers/login_or_register.dart';
import 'package:ecoward/controllers/persistance_handler.dart';
import 'package:ecoward/controllers/providers/UserProvider.dart';
import 'package:ecoward/global/routes.dart';
import 'package:ecoward/http/http_service.dart';
import 'package:ecoward/model/user.dart';
import 'package:ecoward/pages/menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late UserProvider pUser;

  void initState() {
    super.initState();
    _passLoadingScreen();
    pUser = Provider.of<UserProvider>(context, listen: false);
  }

  void _passLoadingScreen() async {
    String? token = await PersistanceHandler().getAccessToken();
    if (token != 'notFound') {
      Response res = await HttpService().makeGetRequestWithToken(getAutoLogin);
      // Response test = await HttpService()
      //     .makeGetRequestWithoutToken("http://195.35.48.105:8082/api/test");
      // final Map<String, dynamic> responseData = jsonDecode(test.body);

      if (res.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(res.body);
        inspect(responseData);
        final int steps = responseData['steps'];
        final int points = responseData['points'];
        final Map<String, dynamic> userData = responseData['user'];

        User user = User.fromJson(userData);
        pUser.setUser(user);
        pUser.setSteps(steps);
        pUser.setPoints(points);

        // Provider.of<UserProvider>(context, listen: false).setUser(user);
        // Provider.of<UserProvider>(context, listen: false).setSteps(steps);
        // User? getUser = await pUser.getUser;

        User? getUser = await pUser.getUser;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Menu()),
        );
      } else {
        PersistanceHandler().delAccessToken();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginOrRegister()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginOrRegister()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
