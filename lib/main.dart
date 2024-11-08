import 'package:ecoward/controllers/login_or_register.dart';
import 'package:ecoward/controllers/providers/ActionProvider.dart';
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
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => Pageprovider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ActionProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingPage(),
      theme: lightMode,
    );
  }
}
