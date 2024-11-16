import 'package:flutter/material.dart';

class RankingTile extends StatelessWidget {
  final String name;
  final int points;
  final int rank;
  final String avatarUrl;
  final bool me;
  const RankingTile({
    Key? key,
    required this.name,
    required this.points,
    required this.rank,
    required this.avatarUrl,
    required this.me,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: me ? Color.fromARGB(255, 236, 221, 4) : Color.fromARGB(255, 250, 250, 250), // Background color
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            // Ombres internes
            BoxShadow(
              color: Color(0xFFBEBEBE), // Couleur de l'ombre foncée
              offset: Offset(7, 7),
              blurRadius: 14,
            ),
            BoxShadow(
              color: Colors.white, // Couleur de l'ombre claire
              offset: Offset(-7, -7),
              blurRadius: 14,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 25,
                backgroundImage: avatarUrl.isNotEmpty
                    ? NetworkImage(avatarUrl)
                    : null, // Image de l'avatar
                backgroundColor: Colors.grey[300],
                child: avatarUrl.isEmpty
                    ? Text(
                        name[0],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 16),
              // Texte principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      '$points pts',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Classement
              Text(
                '$rank',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
