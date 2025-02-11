import 'package:flutter/material.dart';

class ChallengeTile extends StatelessWidget {
  final Map<String, dynamic> challenge;
  final void Function()? onTap;

  const ChallengeTile(
      {super.key, required this.challenge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: const [
            // Ombres internes
            BoxShadow(
              color: Color(0xFFBEBEBE), // Couleur de l'ombre foncée
              offset: Offset(5, 5),
              blurRadius: 5,
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        padding: const EdgeInsets.all(20),
        child: Column(
          // Changé de Row à Column pour une meilleure organisation
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Niveau : ${challenge['progress']['level']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        challenge['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: null,
                      ),
                    ],
                  ),
                ),
                Text(
                  '${challenge['progress']['text']}',
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: null,
                ),
                SizedBox(width: 15),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: LinearProgressIndicator(
                value: challenge['progress']['current'] /
                    challenge['progress']['goal'],
                backgroundColor: Colors.grey.shade200,
                color: Theme.of(context).colorScheme.primary,
                minHeight: 20,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
