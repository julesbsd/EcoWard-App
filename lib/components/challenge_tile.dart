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
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade400),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        padding: const EdgeInsets.all(16),
        child: Column( // Changé de Row à Column pour une meilleure organisation
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
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        maxLines: null,
                      ),
                    ],
                  ),
                ),
                Text(
                  '${challenge['progress']['text']}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  maxLines: null,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: LinearProgressIndicator(
                value: challenge['progress']['current'] / challenge['progress']['goal'],
                backgroundColor: Colors.grey.shade500,
                color: Theme.of(context).colorScheme.primary,
                minHeight: 25,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
