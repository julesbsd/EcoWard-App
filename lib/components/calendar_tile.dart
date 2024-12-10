import 'package:flutter/material.dart';

class CalendarTile extends StatelessWidget {
  final String status;
  final int points;
  final int quantity;
  final String trashname;

  const CalendarTile({
    Key? key,
    required this.status,
    required this.points,
    required this.quantity,
    required this.trashname,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: [
              // Texte principal
              CircleAvatar(
                radius: 20,
                child: Icon(
                  status == 'pending'
                      ? Icons.access_time
                      : status == 'accepted'
                          ? Icons.check
                          : Icons.close,
                  color: status == 'pending'
                      ? Colors.black
                      : status == 'accepted'
                          ? Colors.black
                          : Colors.black,
                  size: 24,
                ),
                backgroundColor: status == 'pending'
                    ? Colors.yellow
                    : status == 'accepted'
                        ? Colors.green
                        : Colors.red,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trashname,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      "Quantité : ${quantity}",
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
                '$points pts',
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
