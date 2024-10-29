import 'dart:convert';
import 'dart:developer';

import 'package:ecoward/components/friends_tile.dart';
import 'package:ecoward/controllers/json_handler.dart';
import 'package:ecoward/controllers/providers/UserProvider.dart';
import 'package:ecoward/global/routes.dart';
import 'package:ecoward/http/http_service.dart';
import 'package:ecoward/pages/account_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  late UserProvider pUser;
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    pUser = Provider.of<UserProvider>(context, listen: false);
  }

  Future<void> _refreshFriends() async {
    // try {
    Response res = await HttpService().makeGetRequestWithToken(getFriends);
    if (res.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(res.body);
      final List<dynamic> friends = responseData['friends'];
      pUser.setFriends(friends);
    } else {
      print('Error: ${res.body}');
    }
  }

  void newFriend() {
    textController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              addFriend(textController.text);
              // clear dialog text
              textController.clear();
              // pop dialog
              Navigator.pop(context);
            },
            child: const Text('Ajouter'),
          )
        ],
      ),
    );
  }

  Future<void> deleteFriend(String email) async {
    showDialog(
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator()));
    try {
      String body = await JSONHandler().removeFriend(email);
      Response res =
          await HttpService().makePostRequestWithToken(removeFriend, body);
      Navigator.pop(context);
      if (res.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(res.body);
        final List<dynamic> friends = responseData['friends'];
        pUser.setFriends(friends);
        setState(() {
          // Appeler la méthode de rafraîchissement après la suppression
          _refreshFriends();
        });
      } else {
        print('Error: ${res.body}');
      }
    } catch (e) {
      setState(() {
        Navigator.pop(context);
        print('Error: $e');
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Une erreur s\'est produite. Veuillez réessayer.'),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  Future<void> addFriend(String email) async {
    showDialog(
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator()));
    try {
      String body = await JSONHandler().addFriend(email);
      Response res =
          await HttpService().makePostRequestWithToken(addNewFriend, body);
      final Map<String, dynamic> responseData = jsonDecode(res.body);

      if (res.statusCode == 200) {
        final List<dynamic> friends = responseData['friends'];
        pUser.setFriends(friends);
        Navigator.pop(context);
        setState(() {
          // Appeler la méthode de rafraîchissement après l'ajout
          _refreshFriends();
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Erreur'),
            content: Text(responseData['error']),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              )
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        Navigator.pop(context);
        print('Error: $e');
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Une erreur s\'est produite. Veuillez réessayer.'),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Liste des amis'),
      //   backgroundColor: Color.fromRGBO(0, 230, 118, 1),
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => const AccountPage()),
      //       );
      //     },
      //   ),
      // ),
      appBar: AppBar(
        title: Text('Profil'),
        backgroundColor: Color.fromRGBO(0, 230, 118, 1),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: newFriend,
        child: Icon(
            color: Theme.of(context).colorScheme.inversePrimary, Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            pUser.user.friends.isEmpty
                ? Expanded(
                    child: Center(child: Text("Vous n'avez pas d'amis.")),
                  )
                : Expanded(
                    child: RefreshIndicator(
                      onRefresh: _refreshFriends,
                      child: ListView.builder(
                        itemCount: pUser.user.friends.length,
                        itemBuilder: (context, index) {
                          final friend = pUser.user.friends[index];
                          return FriendTile(
                            friend: friend,
                            onDeletePressed: () {
                              deleteFriend(friend['email']);
                            },
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
