import 'dart:convert';
import 'dart:developer';

import 'package:ecoward/pages/calendar_page.dart';
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        ],
      ),
      header: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Theme.of(context).colorScheme.primary, // Couleur de l’arc
      backgroundColor: Colors.grey[300]!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.all(20),
            width: 380,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                // Ombres internes
                BoxShadow(
                  color: Color(0xFFBEBEBE), // Couleur de l'ombre foncée
                  offset: Offset(2, 7),
                  blurRadius: 7,
                ),
                BoxShadow(
                  color: Colors.white, // Couleur de l'ombre claire
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
                      child: Image.network(
                        image.isNotEmpty
                            ? image
                            : '$serverImgUrl${pUser.user.profile_photo_url}',
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
                      ),
                    ),
                    
                    // Icône superposée (médaille en bas à droite)
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
                          Icons.emoji_events, // Icône médaille
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 30),

                // --- Textes : Bonjour..., points, classement ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titre (ex: "Bonjour Padideh")
                      const Text(
                        "Bonjour Padideh",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Row:  "398 points | 5ème classement"
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Valeur : Points
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  [
                              Text(
                                '${pUser.user.points}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "points",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),

                          // Séparateur vertical
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            width: 1,
                            height: 30,
                            color: Colors.grey[300],
                          ),

                          // Valeur : Classement
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
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
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    )
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
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Center(
                  child: buildPedometerGauge("Nombre de pas", _steps),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
                Container(
                  // height: 200,
                  child: Image.asset(
                    'lib/assets/homePage3.png',
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                const CarouselWidget(),
                Container(
                  child: Image.asset('lib/assets/homePage2.png',
                      width: MediaQuery.of(context).size.width),
                ),
                const SizedBox(height: 150),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
