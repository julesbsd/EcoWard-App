import 'package:ecoward/controllers/json_handler.dart';
import 'package:ecoward/controllers/persistance_handler.dart';
import 'package:ecoward/global/routes.dart';
import 'package:ecoward/http/http_service.dart';
import 'package:ecoward/main.dart';
// import 'package:ecoward/pages/account_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:permission_handler/permission_handler.dart';

class HeaderWidget extends StatefulWidget {
  final String username;
  final String? profilePhotoUrl;
  final int points;

  const HeaderWidget(
      {super.key,
      required this.username,
      required this.points,
      required this.profilePhotoUrl});

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  late Pedometer _pedometer;
  int _steps = 0;

  @override
  void initState() {
    super.initState();
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _steps = prefs.getInt('steps') ?? 0;
    });
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
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

  Future<void> _logout(BuildContext context) async {
    try {
      String token = await PersistanceHandler().getAccessToken();
      // String body = await JSONHandler().logout(token);

      Response res = await HttpService().makeGetRequestWithToken(getLogout);

      if (res.statusCode == 200) {
        await PersistanceHandler().delAccessToken();
        await PersistanceHandler().delUser();
        // Navigator.pushReplacementNamed(context, '/login');
      } else {
        if (res.statusCode == 401) {
          // Token is not valid, already handled in logoutService
          print('Unauthenticated, redirected to login.');
          // Navigator.pushReplacementNamed(context, '/login');
        } else {
          print('Failed to logout: ${res.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to logout: ${res.body}')),
          );
        }
      }

      // if (response['success']) {
      //   Navigator.pushReplacementNamed(context, '/login');
      // } else {
      //   if (response['statusCode'] == 401) {
      //     // Token is not valid, already handled in logoutService
      //     print('Unauthenticated, redirected to login.');
      //     Navigator.pushReplacementNamed(context, '/login');
      //   } else {
      //     print('Failed to logout: ${response['message']}');
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text('Failed to logout: ${response['message']}')),
      //     );
      //   }
      // }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: 30, left: 16, right: 16, bottom: 16),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 230, 118, 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Bonjour ${widget.username.length > 20 ? "${widget.username.substring(0, 20)}..." : widget.username}',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                ),
              ),
              Row(
                children: [
                  const Icon(
                    size: 40,
                    Icons.notifications,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/profilePage',
                        arguments: {'name': widget.username},
                      );
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        widget.profilePhotoUrl!,
                      ),
                      onBackgroundImageError: (error, stackTrace) {
                        const Icon(Icons.error);
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.red),
                    onPressed: () {
                      _logout(context);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${widget.points} pts',
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
    );
  }
}
