import 'dart:convert';
import 'dart:developer';
import 'package:ecoward/components/challenge_tile.dart';
import 'package:ecoward/controllers/providers/ActionProvider.dart';
import 'package:ecoward/global/routes.dart';
import 'package:ecoward/http/http_service.dart';
import 'package:ecoward/pages/action_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class ActionPage extends StatefulWidget {
  const ActionPage({super.key});

  @override
  State<ActionPage> createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
  late List<dynamic> _challenges;
  bool _isLoading = true;
  late ActionProvider pAction;

  @override
  void initState() {
    super.initState();
    _loadChallenges();
    pAction = Provider.of<ActionProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBottomSheet();
    });
  }

  Future<void> _loadChallenges() async {
    Response res = await HttpService().makeGetRequestWithToken(getChallenges);
    if (res.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(res.body);
      final List<dynamic> challenges = responseData['challenges'];

      setState(() {
        _challenges = challenges;
        _isLoading = false; // Fin du chargement de la requête
      });
    } else {
      setState(() {
        _isLoading = false; // Fin du chargement même en cas d'erreur
      });
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Ligne d'avertissement
              Row(
                children: const [
                  Icon(
                    Icons.warning,
                    color: Colors.yellow,
                    size: 50,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Avertissement !',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Texte principal
              const Text(
                'As-tu le bon équipement pour ramasser tes déchets ?',
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 16),

              // Zone grisée avec nos trois items (gants, masque, sac)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1) Gants
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'lib/assets/gants.png',
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Gants',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Porte constamment des gants pour te protéger '
                                'des coupures et des éraflures.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 2) Masque
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'lib/assets/masque.png',
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Masque',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'En portant des masques, il est crucial '
                                'de se protéger.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 3) Sac de transport
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'lib/assets/poubelle-gants.png',
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Sac de transport',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'N\'oublie pas d\'emporter un sac poubelle '
                                'pour transporter tous tes déchets.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Bouton de confirmation
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Confirmer et procéder au ramassage',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Que souhaites-tu ramasser ?')),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              // width: 400,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: _challenges.length,
                  itemBuilder: (context, index) {
                    final challenge = _challenges[index];
                    return ChallengeTile(
                      challenge: challenge,
                      onTap: () {
                        pAction.setTrash(7);
                        pAction.setChallenge(challenge['id']);
                        log('${challenge['name']} cliqué, id : ${challenge['id']}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ActionForm(
                                  trashId: challenge['id'],
                                  challengeId: challenge['id'])),
                        );
                      },
                    );
                  },
                ),
                // ListView.builder(
                //   itemCount: _challenges.length,
                //   itemBuilder: (context, index) {
                //     final item = _challenges[index];
                //     return ListTile(
                //       contentPadding: const EdgeInsets.symmetric(
                //           vertical: 10.0, horizontal: 10.0),
                //         leading: Image.network(
                //         '$serverImgUrl${item['image']}',
                //         width: 80, // Taille plus grande de l'icône
                //         height: 80,
                //         errorBuilder: (context, error, stackTrace) {
                //           return Image.asset(
                //           'lib/assets/ecoward_logo.png',
                //           width: 80,
                //           height: 80,
                //           );
                //         },
                //         ),
                //       title: Text(
                //         item['name'],
                //         style: const TextStyle(
                //           fontSize: 20, // Taille du texte plus grande
                //         ),
                //       ),
                //       onTap: () {
                //         pAction.setTrash(item['id']);
                //         print('${item['name']} cliqué, id : ${item['id']}');
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //                 builder: (context) => ActionForm(trashId: item['id'])),
                //         );
                //       },
                //     );
                //   },
                // ),
              ),
            ),
    );
  }
}
