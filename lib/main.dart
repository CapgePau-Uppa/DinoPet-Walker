// lib/main.dart
import 'package:dinopet_walker/controllers/HomeController.dart';
import 'package:dinopet_walker/pages/HomeScreen.dart';
import 'package:dinopet_walker/pages/MapScreen.dart';
import 'package:dinopet_walker/pages/SettingsScreen.dart';
import 'package:dinopet_walker/pages/StatisticsScreen.dart';
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
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<String> titles = [
    'Accueil',
    'Statistiques',
    'Carte',
    'Paramètres',
  ];

  final List<Widget> screens = [
    HomeScreen(),
    StatisticsScreen(),
    MapScreen(),
    SettingsScreen(),
  ];

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Myappbar(title: titles[currentIndex]),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}
