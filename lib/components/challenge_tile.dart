import 'package:flutter/material.dart';

class ChallengeTile extends StatelessWidget {
  final Map<String, dynamic> challenge;
  const ChallengeTile({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15.0),
      child: ListTile(
        title: Text(challenge['title']),
        subtitle: Text(challenge['description']),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // Ajouter action lorsque l'utilisateur appuie sur une carte
        },
      ),
    );
  }
}
