import 'dart:convert';
import 'dart:developer';
import 'package:ecoward/components/graph_steps.dart';
import 'package:ecoward/global/routes.dart';
import 'package:ecoward/http/http_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class GraphicPage extends StatefulWidget {
  const GraphicPage({super.key});

  @override
  State<GraphicPage> createState() => _GraphicPageState();
}

class _GraphicPageState extends State<GraphicPage> {
  List<dynamic> _weekSteps = [
    {
      'day': 'Lundi',
      'steps': 10,
    },
    {
      'day': 'Mardi',
      'steps': 10,
    },
    {
      'day': 'Mercredi',
      'steps': 10,
    },
    {
      'day': 'Jeudi',
      'steps': 10,
    },
    {
      'day': 'Vendredi',
      'steps': 10,
    },
    {
      'day': 'Samedi',
      'steps': 10,
    },
    {
      'day': 'Dimanche',
      'steps': 10,
    },
  ]; // Initialisation avec une liste vide
  bool _isLoading = true; // Flag pour l'état de chargement

  @override
  void initState() {
    super.initState();
    _loadWeekSteps();
  }

  Future<void> _loadWeekSteps() async {
    Response res = await HttpService().makeGetRequestWithToken(getWeekSteps);
    if (res.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(res.body);
      final List<dynamic> weekSteps = responseData['weekSteps'];
      inspect(weekSteps);

      setState(() {
        _weekSteps = weekSteps;
        _isLoading = false;
      });
    } else {
      final Map<String, dynamic> errorData = jsonDecode(res.body);
      final String errorMessage = errorData['error'];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Une erreur est survenue'),
            content: Text(errorMessage),
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
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 40, right: 10),
        child: Container(
          height: 300,
          // child: _isLoading
          //     ? const Center(child: CircularProgressIndicator())
          //     : GraphSteps(weekSteps: _weekSteps),
          child: GraphSteps(weekSteps: _weekSteps),
        ),
      ),
    );
  }
}
