import 'package:flutter/material.dart';
import 'package:ecoward/controllers/json_handler.dart';
import 'package:ecoward/controllers/login_or_register.dart';
import 'package:ecoward/controllers/persistance_handler.dart';
import 'package:ecoward/controllers/providers/UserProvider.dart';
import 'package:ecoward/global/routes.dart';
import 'package:ecoward/http/http_service.dart';
import 'package:ecoward/model/user.dart';
import 'package:http/http.dart';
import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:permission_handler/permission_handler.dart';

import '../components/carousel.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Pedometer _pedometer;
  int _steps = 0;
  User? _user;
  late UserProvider pUser;
  String image = '';
  final List<String> imgList = [
    'https://picsum.photos/250?image=9',
    'https://picsum.photos/250?image=10',
    'https://picsum.photos/250?image=11',
    'https://picsum.photos/250?image=12',
  ];

  @override
  void initState() {
    super.initState();
    pUser = Provider.of<UserProvider>(context, listen: false);
    _initializePedometer();
    _loadSteps();
    _initializeWorkmanager();
  }

  Future<void> _initializePedometer() async {
    if (await Permission.activityRecognition.request().isGranted) {
      _startPedometer();
    } else {
      // Handle permission denial
      print("Permission denied for activity recognition");
    }
  }

  Future<void> _loadSteps() async {
    // Récupérer les pas depuis le Provider
    int savedSteps = pUser.user.steps;

    // Actualiser l'UI avec la valeur récupérée
    setState(() {
      _steps = savedSteps;
    });

    print('Steps loaded: $savedSteps');
  }

  void _startPedometer() {
    _pedometer = Pedometer();
    Pedometer.stepCountStream.listen(_onStepCount);
  }

  void _onStepCount(StepCount stepCount) async {
    setState(() {
      _steps = stepCount.steps;
    });
    await _saveSteps(stepCount.steps);
    // await saveStepsService(stepCount.steps);
    String body = await JSONHandler().saveSteps(stepCount.steps);
    Response res =
        await HttpService().makePostRequestWithToken(postSaveStep, body);
    if (res.statusCode == 201) {
      print("Steps saved successfully");
    } else {
      print("Failed to save steps: ${res.body}");
    }
  }

  Future<void> _saveSteps(int steps) async {
    pUser.setSteps(steps);
  }

  void _initializeWorkmanager() {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

    // Tâche pour sauvegarder les pas toutes les 2 minutes
    Workmanager().registerPeriodicTask(
      "1",
      "saveStepsTask",
      frequency: const Duration(minutes: 15),
    );

    // Tâche pour réinitialiser les pas à minuit
    Workmanager().registerPeriodicTask(
      "2",
      "resetStepsTask",
      frequency: const Duration(days: 1),
      initialDelay: Duration(
        hours: 24 - DateTime.now().hour,
        minutes: 60 - DateTime.now().minute,
        seconds: 60 - DateTime.now().second,
      ),
    );
  }

  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      if (task == "saveStepsTask") {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        int steps = prefs.getInt('steps') ?? 0;
        // await saveStepsService(steps);
        String body = await JSONHandler().saveSteps(steps);
        Response res =
            await HttpService().makePostRequestWithToken(postSaveStep, body);
        if (res.statusCode == 201) {
          print("Steps saved successfully");
        } else {
          print("Failed to save steps: ${res.body}");
        }
      } else if (task == "resetStepsTask") {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('steps', 0); // Réinitialiser les pas à zéro
        print("Steps reset to 0 at midnight");
      }
      return Future.value(true);
    });
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(0, 230, 118, 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: 10),
                Text(
                  '${pUser.user.points} pts',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  '$_steps / 10 000 Pas',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: LinearProgressIndicator(
                    value: _steps / 10000,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    minHeight: 25,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          const CarouselWidget(),
          Container(
            // padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  // height: 200,
                  child: Image.asset(
                    'lib/assets/homePage1.png',
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
