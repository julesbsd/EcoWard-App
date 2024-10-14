import 'package:flutter/material.dart';

class ChallengeTile extends StatelessWidget {
  final Map<String, dynamic> challenge;
  const ChallengeTile({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            Theme.of(context).colorScheme.secondary, // Couleur de fond blanche
        borderRadius:
            BorderRadius.circular(20), // Coins arrondis plus prononcés
        border: Border.all(color: Colors.grey.shade400), // Bordure grise
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      padding:
          const EdgeInsets.all(16), // Padding interne pour aérer le contenu
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Espacement entre texte et icône
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  challenge['description'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  maxLines:
                      null, // Permet à la description de s'étendre sur plusieurs lignes
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.greenAccent, // Couleur de fond verte
            child: IconButton(
              icon: const Icon(
                Icons.arrow_forward,
                size: 16,
                color: Colors.white,
              ),
              onPressed: () {
                // Ajouter action lorsque l'utilisateur appuie sur l'icône
              },
            ),
          ),
        ],
      ),
    );
  }
}
