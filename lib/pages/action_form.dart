import 'package:ecoward/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ActionForm extends StatefulWidget {
  const ActionForm({super.key});

  @override
  State<ActionForm> createState() => _ActionFormState();
}

class _ActionFormState extends State<ActionForm> {
  int quantity = 1;
  File? _imageTop;
  File? _imageBottom;

  Future<void> _pickImage(bool isTop) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      setState(() {
        if (isTop) {
          _imageTop = File(pickedFile.path);
        } else {
          _imageBottom = File(pickedFile.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Bravo !',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _pickImage(true),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _imageTop == null
                        ? const Icon(Icons.camera_alt, color: Colors.grey)
                        : Image.file(
                            _imageTop!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) quantity--;
                        });
                      },
                    ),
                    Text(
                      'QT : $quantity',
                      style: const TextStyle(fontSize: 20),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Tu l’as jeté ?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _pickImage(false),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _imageBottom == null
                        ? const Icon(Icons.camera_alt, color: Colors.grey)
                        : Image.file(
                            _imageBottom!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.check_circle, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Important ! Pense à ajouter une photo te montrant jeter le déchet pour valider tes points. Les photos sont régulièrement vérifiées par notre équipe.",
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            // ElevatedButton(
            //   onPressed: () {},
            //   child: const Text("Valider"),
            //   style: ElevatedButton.styleFrom(
            //     minimumSize: const Size(double.infinity, 48),
            //   ),
            // ),
            // const SizedBox(height: 8),
            // ElevatedButton(
            //   onPressed: () {},
            //   child: const Text("Valider et nouveau"),
            //   style: ElevatedButton.styleFrom(
            //     // primary: Colors.lightGreen,
            //     // onPrimary: Colors.white,
            //     minimumSize: const Size(double.infinity, 48),
            //   ),
            // ),
            MyButton(
              text: 'Valider',
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
