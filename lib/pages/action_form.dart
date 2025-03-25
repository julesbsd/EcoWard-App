import 'dart:convert';
import 'dart:developer';
import 'package:ecoward/controllers/providers/UserProvider.dart';
import 'package:ecoward/pages/action_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ecoward/components/animationCheck.dart';
import 'package:ecoward/components/my_button.dart';
import 'package:ecoward/controllers/json_handler.dart';
import 'package:ecoward/global/routes.dart';
import 'package:ecoward/http/http_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class ActionForm extends StatefulWidget {
  final int trashId;
  final int challengeId;

  const ActionForm(
      {super.key, required this.trashId, required this.challengeId});

  @override
  State<ActionForm> createState() => _ActionFormState();
}

class _ActionFormState extends State<ActionForm> {
  int quantity = 1;
  File? _imageTop;
  File? _imageBottom;
  bool _isLoading = false;
  bool _isSuccess = false;
  late UserProvider pUser;

  void initState() {
    super.initState();
    pUser = Provider.of<UserProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationPermission();
    });
  }

  Future<void> _pickImage(bool isTop) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 500, // Largeur max en pixels (redimensionnement)
      maxHeight: 500, // Hauteur max en pixels
      imageQuality: 50, // Compression (0-100)
    );

    if (pickedFile != null) {
      setState(() {
        if (isTop) {
          _imageTop = File(pickedFile.path);
        } else {
          _imageBottom = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Les services de localisation sont désactivés.'),
        ),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Les permissions de localisation sont refusées.'),
          ),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Les permissions de localisation sont refusées de façon permanente.'),
        ),
      );
      return;
    }
    _pickImage(true);
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> sendAction() async {
    if (_imageTop != null && _imageBottom != null) {
      setState(() {
        _isLoading = true;
      });

      String base64ImageTop = base64Encode(await _imageTop!.readAsBytes());

      String base64ImageBottom =
          base64Encode(await _imageBottom!.readAsBytes());

      Position position = await _getCurrentPosition();
      double latitude = position.latitude;
      double longitude = position.longitude;

      String body = await JSONHandler().sendAction(
        widget.trashId,
        widget.challengeId,
        quantity,
        base64ImageTop,
        base64ImageBottom,
        latitude,
        longitude,
      );

      Response res =
          await HttpService().makePostRequestWithToken(postAction, body);

      final Map<String, dynamic> responseData = jsonDecode(res.body);
      if (responseData['status'] == 'success') {
        final int points = responseData['points'];
        pUser.setPoints(points);

        setState(() {
          _isLoading = false;
          _isSuccess = true;
        });

        await Future.delayed(const Duration(seconds: 1));

        setState(() {
          _isSuccess = false;
        });

        Navigator.pop(context);
      } else {
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erreur'),
              content: Text('Erreur: ${responseData["message"]}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Show an error message if images are missing
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez ajouter les deux photos avant de valider.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Bravo !',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 50),
                    Image.asset('lib/assets/bonjour.png', width: 160),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _pickImage(true),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _imageTop == null
                            ? const Icon(Icons.camera_alt, color: Colors.grey)
                            : Image.file(
                                _imageTop!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.remove_circle,
                            size: 30,
                            color: quantity > 1
                                ? Colors.grey.shade800
                                : Colors.grey.shade200,
                          ),
                          onPressed: () {
                            setState(() {
                              if (quantity > 1) quantity--;
                            });
                          },
                        ),
                        Text(
                          'QT : $quantity',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontFamily: 'Raleway'),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle,
                              size: 30, color: Colors.grey.shade800),
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    const SizedBox(width: 50),
                    Text(
                      'Tu l’as jeté ?',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _pickImage(false),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _imageBottom == null
                            ? const Icon(Icons.camera_alt, color: Colors.grey)
                            : Image.file(
                                _imageBottom!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          // const Icon(Icons.check_circle, color: Colors.green),
                          Image.asset('lib/assets/throw.jpg', fit: BoxFit.cover),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Important ! Pense à ajouter une photo te montrant jeter le déchet pour valider tes points. Les photos sont régulièrement vérifiées par notre équipe.",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontFamily: 'Raleway'),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                MyButton(
                    text: 'Valider',
                    color: Theme.of(context).colorScheme.primary,
                    textColor: Colors.white,
                    onTap: _isLoading
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirmation'),
                                  content: Text(
                                    'Êtes-vous sûr de vouloir valider cette action ?',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Annuler',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        sendAction();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Valider',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(color: Colors.green),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                              strokeWidth: 2,
                            ),
                          )
                        : const Text("Valider",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: 'Raleway'))),
                const SizedBox(height: 15),
                MyButton(
                    text: "Nouveau ramassage",
                    textColor: Theme.of(context).colorScheme.inversePrimary,
                    color: Colors.white,
                    onTap: () {}),
                const SizedBox(height: 15),
              ],
            ),
          ),
          if (_isSuccess) Center(child: AnimatedCheck()),
        ],
      ),
    );
  }
}
