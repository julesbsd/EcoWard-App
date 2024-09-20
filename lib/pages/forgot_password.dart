import 'package:ecoward/components/my_button.dart';
import 'package:ecoward/controllers/login_or_register.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? _errorMessage;

  Future<void> _resetPassword(email, String password) async {
    try {

      if(email.isEmpty || password.isEmpty) {
        setState(() {
          _errorMessage = 'Veuillez remplir tous les champs.';
        });
        return;
      }
      // Show loading indicator

      if (passwordController.text != confirmPasswordController.text) {
        setState(() {
          _errorMessage = 'Les mots de passe ne correspondent pas.';
        });
        return;
      }
      showDialog(
          context: context,
          builder: (context) => const Center(child: CircularProgressIndicator()));
      // final response = await resetPasswordService(email, password);

      // if (response['success']) {
      //   // redirect to login page
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => const LoginOrRegister(),
      //     ),
      //   );
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text('Mot de passe réinitialisé. Connectez-vous'),
      //     ),
      //   );
      // } else {
      //   setState(() {
      //     Navigator.pop(context);
      //     _errorMessage = _extractErrorMessage(response['error']);
      //   });
      // }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    }
  }

  String _extractErrorMessage(Map<String, dynamic> errorResponse) {
    if (errorResponse.containsKey('error')) {
      final error = errorResponse['error'];
      if (error is Map<String, dynamic>) {
        final errorValues = error.values.expand((element) => element).toList();
        return errorValues.join(' ');
      } else if (error is String) {
        return error;
      }
    }
    if (errorResponse.containsKey('message')) {
      return errorResponse['message'];
    }
    return 'Connexion échouée. Veuillez réessayer.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 80),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[100], // Fond pour mieux voir le logo
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow,
                        offset: const Offset(7.0, 7.0),
                        blurRadius: 10,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(
                          25.0), // Ajuster le padding si nécessaire
                      child: Image.asset(
                        'lib/assets/ecoward_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60.0),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow,
                        offset: const Offset(8.0, 8.0),
                        blurRadius: 8,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'username@gmail.com',
                      hintStyle: Theme.of(context).textTheme.displayLarge,
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                    ),
                    obscureText: false,
                  ),
                ),
                const SizedBox(height: 25.0),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow,
                        offset: const Offset(8.0, 8.0),
                        blurRadius: 8,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Mot de passe',
                      hintStyle: Theme.of(context).textTheme.displayLarge,
                      prefixIcon: const Icon(Icons.lock_outlined),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 25.0),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow,
                        offset: const Offset(8.0, 8.0),
                        blurRadius: 8,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      hintText: 'Confirmation du mot de passe',
                      hintStyle: Theme.of(context).textTheme.displayLarge,
                      prefixIcon: const Icon(Icons.lock_outlined),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 10),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 30.0),
                MyButton(
                    text: 'Réinitialiser le mot de passe',
                    onTap: () {
                      _resetPassword(
                          emailController.text, passwordController.text);
                    }),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginOrRegister(),
                          ),
                        );
                      },
                      child: Text(
                        'Connexion',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontFamily: 'Raleway',
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
