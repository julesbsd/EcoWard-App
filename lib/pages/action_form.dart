import 'package:flutter/material.dart';

class ActionForm extends StatefulWidget {
  const ActionForm({super.key});

  @override
  State<ActionForm> createState() => _ActionFormState();
}

class _ActionFormState extends State<ActionForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
