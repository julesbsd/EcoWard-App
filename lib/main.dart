import 'package:ecoward/controllers/login_or_register.dart';
import 'package:ecoward/controllers/providers/PageProvider.dart';
import 'package:ecoward/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/providers/UserProvider.dart';
import 'package:ecoward/theme/light_mode.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(), // Ajout de votre UserProvider ici
        ),
        ChangeNotifierProvider(
          create: (_) => Pageprovider(), // Ajout de votre UserProvider ici
        ),
      ],
      child: MyApp(), // Votre classe principale de l'application
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingPage(),
      theme: lightMode,
    );
  }
}
