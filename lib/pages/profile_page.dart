import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ecoward/components/my_button.dart';
import 'package:ecoward/controllers/json_handler.dart';
import 'package:ecoward/controllers/providers/UserProvider.dart';
import 'package:ecoward/global/routes.dart';
import 'package:ecoward/http/http_service.dart';
import 'package:ecoward/model/user.dart';
import 'package:ecoward/pages/menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var profileImage = '';
  late UserProvider pUser;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();
    pUser = Provider.of<UserProvider>(context, listen: false);
    _nameController.text = pUser.user.name;
    _emailController.text = pUser.user.email;
    profileImage = pUser.user.profile_photo_url;
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      String body;
      if (_image != null) {
        body = await JSONHandler().updateUser(
          _nameController.text,
          _emailController.text,
          profileImage,
        );
      } else {
        body = await JSONHandler().updateUser(
          _nameController.text,
          _emailController.text,
          pUser.user.profile_photo_url, // ou ne pas inclure le paramètre selon l'implémentation de JSONHandler
        );
      }
      Response res = await HttpService().makePostRequestWithToken(
        updateUser,
        body,
      );
      inspect(body);
      if (res.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(res.body);
        final Map<String, dynamic> userData = responseData['user'];
        final int points = responseData['points'];
        final String newProfileImage = responseData['profile_photo_url'];
        print(res.body);
        User user = User.fromJson(userData);
        pUser.setPoints(points);
        pUser.setUser(user);
        pUser.setProfileImage(newProfileImage);
        Navigator.pop(context);
      } else {
        print(res.body);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Error: ${res.body}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
        print('Error: ${res.body}');
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      final bytes = await pickedFile.readAsBytes();
      profileImage = base64Encode(bytes);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon profil'),
        // backgroundColor: Color.fromRGBO(0, 230, 118, 1),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: ClipOval(
                        child: Image.network(
                          '$serverImgUrl${pUser.user.profile_photo_url}',
                          width: 120,
                          height: 120,
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
                    ),
                  ),
                  Container(
                    child: Text(
                      pUser.user.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "CaviarDream",
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Informations personnelles',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
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
                      readOnly: true,
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintStyle: Theme.of(context).textTheme.bodyLarge,
                        prefixIcon: const Icon(Icons.lock),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                      ),
                      obscureText: false,
                    ),
                  ),
                  SizedBox(height: 20.0),
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
                      readOnly: true,
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintStyle: Theme.of(context).textTheme.displayLarge,
                        prefixIcon: const Icon(Icons.lock),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                      ),
                      obscureText: false,
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Modifier le mot de passe',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // ElevatedButton(
                  //   onPressed: _updateUser,
                  //   child: Text('Mettre à jour'),
                  // ),
                  MyButton(
                      text: "Enregistrer les modification",
                      onTap: _updateUser,
                      color: Theme.of(context).colorScheme.primary,
                      textColor: Colors.black),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
