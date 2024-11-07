import 'dart:convert';
import 'dart:developer';
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
  late List<dynamic> _trashes;
  bool _isLoading = true;
  late ActionProvider pAction;

  @override
  void initState() {
    super.initState();
    _loadTrashes();
    pAction = Provider.of<ActionProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBottomSheet();
    });
  }

  Future<void> _loadTrashes() async {
    Response res = await HttpService().makeGetRequestWithToken(getTrashes);
    if (res.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(res.body);
      final List<dynamic> trashes = responseData['trashes'];

      setState(() {
        _trashes = trashes;
        _isLoading = false; // Fin du chargement de la requête
        inspect(pAction);
      });
    } else {
      inspect(pAction);
      print('Error: ${res.body}');
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
              Row(
                children: const [
                  Icon(
                    Icons.warning,
                    color: Colors.yellow,
                    size: 50,
                  ),
                  SizedBox(width: 8),
                  Text('Avertissement !',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'As-tu le bon équipement pour ramasser tes déchets ?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('🧤 Gants',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(
                        'Porte constamment des gants pour te protéger des coupures et des éraflures.'),
                    SizedBox(height: 10),
                    Text('😷 Masque',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(
                        'En portant des masques, il est crucial de se protéger.'),
                    SizedBox(height: 10),
                    Text('🗑️ Sac de transport',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(
                        'N\'oublie pas d\'emporter un sac poubelle pour transporter tous tes déchets.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
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
                  itemCount: _trashes.length,
                  itemBuilder: (context, index) {
                    final item = _trashes[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      leading: Image.network(
                        '$serverImgUrl${item['image']}',
                        width: 80, // Taille plus grande de l'icône
                        height: 80,
                      ),
                      title: Text(
                        item['name'],
                        style: const TextStyle(
                          fontSize: 20, // Taille du texte plus grande
                        ),
                      ),
                      onTap: () {
                        pAction.setTrash(item['id']);
                        print('${item['name']} cliqué, id : ${item['id']}');
                        inspect(pAction);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ActionForm()),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
    );
  }
}
