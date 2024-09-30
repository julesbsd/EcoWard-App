import 'package:ecoward/components/challenge_tile.dart';
import 'package:flutter/material.dart';

class ChallengePage extends StatelessWidget {
  const ChallengePage({super.key});
  static const challenge = [
    {
      'title': 'Nettoyage de la plage',
      'description': 'Plage de la Garoupe',
      'date': 'Samedi 12 juin',
      'participants': 12,
    },
    {
      'title': 'Ramassage de déchets',
      'location': 'Parc de la Roseraie',
      'date': 'Dimanche 13 juin',
      'participants': 5,
    },
    {
      'title': 'Plantation d\'arbres',
      'location': 'Forêt de la Valmasque',
      'date': 'Samedi 19 juin',
      'participants': 8,
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // _buildFilterButton('À la une', true),
                  // _buildFilterButton('À proximité', false),
                  // _buildFilterButton('Toutes', false),
                  // _buildFilterButton('Mes actions', false),
                ],
              ),
              const SizedBox(height: 20),
              // Flexible(
              //   fit: FlexFit.loose,
              //   child: ListView.builder(
              //     itemCount: challenge.length,
              //     itemBuilder: (context, index) {
              //       final item = challenge[index];
              //       return ChallengeTile(
              //         challenge: item,
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.all(20.0),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       const Text(
    //         'Le ramassage est plus amusant avec des amis ! '
    //         'Lance une action et trouve des partenaires EcoWard pour te rejoindre.',
    //         style: TextStyle(fontSize: 16),
    //       ),
    //       const SizedBox(height: 20),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           _buildFilterButton('À la une', true),
    //           _buildFilterButton('À proximité', false),
    //           _buildFilterButton('Toutes', false),
    //           _buildFilterButton('Mes actions', false),
    //         ],
    //       ),
    //       const SizedBox(height: 20),
    //       Flexible(
    //         fit: FlexFit.loose,
    //         child: ListView.builder(
    //           itemCount: challenge.length,
    //           itemBuilder: (context, index) {
    //             final item = challenge[index];
    //             return ChallengeTile(
    //               challenge: item,
    //             );
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget _buildFilterButton(String title, bool isSelected) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? Colors.black : Colors.white,
        // primary: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.black),
        ),
      ),
      onPressed: () {},
      child: Text(title),
    );
  }
}
