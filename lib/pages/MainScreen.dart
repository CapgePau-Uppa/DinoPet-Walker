import 'package:dinopet_walker/models/DinoPet.dart';
import 'package:dinopet_walker/pages/HomeScreen.dart';
import 'package:dinopet_walker/pages/MapScreen.dart';
import 'package:dinopet_walker/pages/SettingsScreen.dart';
import 'package:dinopet_walker/pages/StatisticsScreen.dart';
import 'package:dinopet_walker/widgets/common/BottomNavBar.dart';
import 'package:dinopet_walker/widgets/common/MyAppBar.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final DinoPet dinoPet; 

  const MainScreen({super.key, required this.dinoPet});

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
      HomeScreen(dinoPet: widget.dinoPet), 
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
