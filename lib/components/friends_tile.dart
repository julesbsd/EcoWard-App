import 'package:flutter/material.dart';

class FriendTile extends StatelessWidget {
  final Map<String, dynamic> friend;
  final void Function() onDeletePressed;
  const FriendTile(
      {super.key, required this.friend, required this.onDeletePressed});

  @override
  Widget build(BuildContext context) {
    final String profilePhotoUrl =
        friend['profile_photo_url'] ?? 'https://via.placeholder.com/150';

    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: ListTile(
            leading: ClipOval(
              child: Image.network(
                profilePhotoUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error);
                },
              ),
            ),
            title: Text(
              friend['name'],
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDeletePressed,
                ),
              ],
            )));
  }
}
