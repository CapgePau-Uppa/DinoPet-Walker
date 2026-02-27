import 'package:dinopet_walker/controllers/DinoController.dart';
import 'package:dinopet_walker/controllers/HomeController.dart';
import 'package:dinopet_walker/controllers/StatisticsController.dart';
import 'package:dinopet_walker/pages/LoginScreen.dart';
import 'package:dinopet_walker/pages/SelectionScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DinoController()),
        ChangeNotifierProxyProvider<DinoController, HomeController>(
          create: (ctx) => HomeController(dinoController: ctx.read<DinoController>()),
          update: (ctx, dino, previous) {
            previous!.dinoController = dino;
            return previous;
          }
        ),
        ChangeNotifierProvider(create: (_) => StatisticsController())

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DinoPet',
      home: LoginScreen(),
    );
  }
}



