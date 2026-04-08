import 'package:dinopet_walker/controllers/activity_controller.dart';
import 'package:dinopet_walker/controllers/dino_controller.dart';
import 'package:dinopet_walker/controllers/home_controller.dart';
import 'package:dinopet_walker/controllers/firestore/user_controller.dart';
import 'package:dinopet_walker/utils/theme_helper.dart';
import 'package:dinopet_walker/widgets/clippers/bowl_clipper.dart';
import 'package:dinopet_walker/widgets/clippers/header_clipper.dart';
import 'package:dinopet_walker/widgets/debug_menu.dart';
import 'package:dinopet_walker/widgets/dino/animated_dino_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../widgets/home/user_header.dart';
import '../widgets/home/gauge_widget.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _homeKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeController>().init();
      context.read<UserController>().getCurrentUser();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<HomeController>().refreshSteps();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeController = context.watch<HomeController>();
    final dinoController = context.watch<DinoController>();
    final userController = context.watch<UserController>();
    final activityController = context.watch<ActivityController>();

    final username = userController.username;
    final currentDino = dinoController.dinoPet!;
    final dominantSport = activityController.dominantSport;

    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: _homeKey,
      backgroundColor: const Color(0xFFF5F7FA),
      endDrawer: kDebugMode ? const DebugMenu() : null,

      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ClipPath(
              clipper: HeaderClipper(), 
              child: Container(
                height: size.height * 0.38, 
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: BowlClipper(), 
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                height: size.height * 0.45,
                width: size.width,
                decoration: ThemeHelper.getBackgroundDecoration(dominantSport),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onLongPress: () {
                        if (kDebugMode) {
                          _homeKey.currentState?.openEndDrawer();
                        }
                      },
                      child: UserHeader(
                        username: username,
                        userLevel: currentDino.level,
                        streak: homeController.streak,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        GaugeWidget(
                          value: homeController.currentSteps,
                          maxValue: homeController.goalSteps,
                        ),
                        Positioned(
                          top: 280 - 150,
                          child: AnimatedDinoWidget(
                            dinoPet: currentDino,
                            onStageEvolved: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 220),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Text(
                            currentDino.type.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: currentDino.type.innerColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentDino.currentStage.getName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${currentDino.getTotalStepsCollected()}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
