import 'dart:convert';
import 'dart:developer';

import 'package:ecoward/pages/statistics_page.dart';
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
import 'package:percent_indicator/percent_indicator.dart';
import 'package:ecoward/components/drawer.dart';
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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    pUser = Provider.of<UserProvider>(context, listen: false);
    _initializePedometer();
    _loadSteps();
    _initializeWorkmanager();
    _loadPoints();
  }

  Future<void> _initializePedometer() async {
    if (await Permission.activityRecognition.request().isGranted) {
      _startPedometer();
    } else {
      // Handle permission denial
      print("Permission denied for activity recognition");
    }
  }

  Future<void> _loadPoints() async {
    Response res = await HttpService().makeGetRequestWithToken(getPoints);
    if (res.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(res.body);
      final int points = responseData['points'];
      print("Points récupérés : ${res.body}");

      pUser.setPoints(points);
    } else {
      print("Failed to load points: ${res.body}");
    }
  }

  Future<void> _loadSteps() async {
    // Récupérer les pas depuis le Provider
    int savedSteps = pUser.user.steps;
    print('steps from provider: $savedSteps');
    print('puser.user: ${pUser.user.steps}');
    // Actualiser l'UI avec la valeur récupérée
    setState(() {
      _steps = savedSteps;
    });

    print('Steps loaded: $savedSteps');
  }

  void _startPedometer() {
    _pedometer = Pedometer();
    _steps = pUser.user.steps; // Valeur initiale depuis le provider

    int? baseSteps; // Pour stocker la référence initiale du pédomètre

    Pedometer.stepCountStream.listen((StepCount event) {
      if (baseSteps == null) {
        baseSteps = event.steps;
        return;
      }

      // Calculer uniquement les nouveaux pas depuis le début de l'écoute
      int stepsSinceStart = event.steps - baseSteps!;
      int totalSteps = pUser.user.steps + stepsSinceStart;

      if (totalSteps != _steps) {
        // Éviter les mises à jour inutiles
        _onStepCount(totalSteps);
      }
    });
  }

  void _onStepCount(int totalSteps) async {
    // Mettre à jour le provider et l'état local
    pUser.setSteps(totalSteps);
    setState(() {
      _steps = totalSteps;
    });

    // Sauvegarder en DB
    String body = await JSONHandler().saveSteps(totalSteps);
    Response res =
        await HttpService().makePostRequestWithToken(postSaveStep, body);

    if (res.statusCode == 201) {
      print("Steps saved successfully: $totalSteps");
      final Map<String, dynamic> responseData = jsonDecode(res.body);
      final int points = responseData['points'];
      pUser.setPoints(points);
    } else {
      print("Failed to save steps: ${res.body}");
    }
  }

  Future<void> _saveSteps(int steps) async {
    setState(() {
      _steps = steps;
    });
    pUser.setSteps(steps);

    // Sauvegarder dans SharedPreferences aussi
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('steps', steps);
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

  Widget buildPedometerGauge(String title, int steps, {int dailyGoal = 10000}) {
    double percent = (steps / dailyGoal).clamp(0.0, 1.0);
    print('percent: $percent');
    return CircularPercentIndicator(
      radius: 65,
      lineWidth: 11.0,
      percent: percent, // Entre 0.0 et 1.0
      arcBackgroundColor:
          Theme.of(context).colorScheme.secondary, // Couleur de fond de l'arc
      animation: true, // Si vous voulez une animation
      arcType: ArcType.FULL, // Demi-cercle
      startAngle: 0,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_walk,
              size: 30.0, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 10),
          Text(
            '$steps',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
      header: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Theme.of(context).colorScheme.primary, // Couleur de l’arc
      backgroundColor: Colors.grey[300]!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: DrawerComponent.buildMenuDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior:
                  Clip.none, // pour permettre à l'icône de dépasser si besoin
              children: [
                // GestureDetector(
                //   onTap: () {},
                //   child: ,
                // ),
                GestureDetector(
                  onTap: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    width: 380,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFBEBEBE),
                          offset: Offset(5, 7),
                          blurRadius: 5,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-7, -7),
                          blurRadius: 14,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // --- Avatar + médaille ---
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipOval(
                              child: Consumer<UserProvider>(
                                builder: (context, userProvider, child) {
                                  return Image.network(
                                    '$serverImgUrl${userProvider.user.profile_photo_url}',
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.account_circle,
                                        size: 60,
                                        color: Colors.grey,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              right: -2,
                              bottom: -2,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 2,
                                    )
                                  ],
                                ),
                                child: const Icon(
                                  Icons.emoji_events,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 30),
                        // --- Textes ---
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bonjour ${pUser.user.name}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "CaviaDream",
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${pUser.user.points}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        "points",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    width: 1,
                                    height: 30,
                                    color: Colors.grey[300],
                                  ),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "5ème",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "classement",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Transform.rotate(
                    angle: 25 * 3.1415926535897932 / 180,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(255, 255, 244, 144),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.notifications_outlined,
                          size: 25,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              // height: 200,
              child: Image.asset(
                'lib/assets/homePageChallenges.png',
                width: MediaQuery.of(context).size.width,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(8.0),
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      // Ombres internes
                      BoxShadow(
                        color: Color(0xFFBEBEBE), // Couleur de l'ombre foncée
                        offset: Offset(3, 5),
                        blurRadius: 5,
                      ),
                      BoxShadow(
                        color: Colors.white, // Couleur de l'ombre claire
                        offset: Offset(-7, -7),
                        blurRadius: 14,
                      ),
                    ],
                  ),
                  child: Center(
                    child: buildPedometerGauge("Nombre de pas", _steps),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      // Ombres internes
                      BoxShadow(
                        color: Color(0xFFBEBEBE), // Couleur de l'ombre foncée
                        offset: Offset(3, 5),
                        blurRadius: 5,
                      ),
                      BoxShadow(
                        color: Colors.white, // Couleur de l'ombre claire
                        offset: Offset(-7, -7),
                        blurRadius: 14,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        'CO2 économisé',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Center(
                        child: Icon(Icons.cloud_outlined,
                            size: 100,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      Text(
                        '259 g',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              // padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const CarouselWidget(),
                  Container(
                    child: Image.asset('lib/assets/homePage2.png',
                        width: MediaQuery.of(context).size.width),
                  ),
                  Container(
                    // height: 200,
                    child: Image.asset(
                      'lib/assets/homePage3.png',
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  const SizedBox(height: 150),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
