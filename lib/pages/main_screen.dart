import 'package:dinopet_walker/pages/home_screen.dart';
import 'package:dinopet_walker/pages/map_screen.dart';
import 'package:dinopet_walker/pages/settings_screen.dart';
import 'package:dinopet_walker/pages/statistics_screen.dart';
import 'package:dinopet_walker/widgets/common/bottom_navbar.dart';
import 'package:dinopet_walker/widgets/common/my_appbar.dart';
import 'package:flutter/material.dart';

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

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      HomeScreen(), 
      StatisticsScreen(),
      MapScreen(),
      SettingsScreen(),
    ];
  }

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
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}
