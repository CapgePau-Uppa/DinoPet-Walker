import 'package:dinopet_walker/controllers/HomeController.dart';
import 'package:dinopet_walker/pages/HomeScreen.dart';
import 'package:dinopet_walker/pages/MapScreen.dart';
import 'package:dinopet_walker/pages/SettingsScreen.dart';
import 'package:dinopet_walker/pages/StatisticsScreen.dart';
import 'package:dinopet_walker/pages/SelectionScreen.dart';
import 'package:dinopet_walker/widgets/BottomNavBar.dart';
import 'package:dinopet_walker/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => HomeController())],
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
      home: SelectionScreen(),
    );
  }
}



