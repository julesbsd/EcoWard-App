import 'package:ecoward/components/challenge_tile.dart';
import 'package:flutter/material.dart';

class ChallengePage extends StatelessWidget {
  const ChallengePage({super.key});
  static const challenge = [
    {
      'title': 'Défi des 50 objets',
      'description': 'Trouvez et ramassez 50 objets différents hetés dans la nature',
    },
    {
      'title': 'Challenge de recyclage',
      'description': 'Recyclez au moins cinq types de déchets différents en une semaine',
    },
    {
      'title': 'Défi des mégots',
      'description': 'Collectez un maximum de mégots de cigarettes en une journée',
    },
    {
      'title': 'Défi des 30 jours',
      'description': 'Ramassez au moins un déchet par jour pendant 30 jours',
    },
    {
      'title': 'Défi zéro plastique',
      'description': 'Vivez une semaine sans utiliser de plastique à usage unique et partagez vos astuces',
    },
    {
      'title': 'Défi des paires',
      'description': 'Trouvez et ramasser des paires d\'objets (deux bouteilles, deux canettes, etc.)',
    },
    {
      'title': 'Défi des 5 minutes',
      'description': 'Ramassez autant de déchets que possible en seulement 5 minutes',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Le ramassage est plus amusant avec des amis ! '
                'Lance une action et trouve des partenaires EcoWard pour te rejoindre.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                // fit: FlexFit.loose,
                child: ListView.builder(
                  itemCount: challenge.length,
                  itemBuilder: (context, index) {
                    final item = challenge[index];
                    return ChallengeTile(
                      challenge: item,
                      onTap: () {
                        // Navigator.pushNamed(context, Routes.action);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildFilterButton(String title, bool isSelected) {
  //   return TextButton(
  //     style: TextButton.styleFrom(
  //       backgroundColor: isSelected ? Colors.black : Colors.white,
  //       // primary: isSelected ? Colors.white : Colors.black,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
  //         side: BorderSide(color: Colors.black),
  //       ),
  //     ),
  //     onPressed: () {},
  //     child: Text(title),
  //   );
  // }
}
