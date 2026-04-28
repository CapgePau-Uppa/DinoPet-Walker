import 'package:dinopet_walker/controllers/activity/activity_controller.dart';
import 'package:dinopet_walker/controllers/dino/dino_controller.dart';
import 'package:dinopet_walker/controllers/home_controller.dart';
import 'package:dinopet_walker/controllers/user/user_controller.dart';
import 'package:dinopet_walker/pages/inventory_screen.dart';
import 'package:dinopet_walker/utils/theme_helper.dart';
import 'package:dinopet_walker/widgets/clippers/bowl_clipper.dart';
import 'package:dinopet_walker/widgets/clippers/header_clipper.dart';
import 'package:dinopet_walker/widgets/home/debug_menu.dart';
import 'package:dinopet_walker/widgets/dino/dino_details_widget.dart';
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
    final dinoNature = activityController.dinoNature;

    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: _homeKey,
      backgroundColor: const Color(0xFFF5F7FA),
      endDrawer: kDebugMode ? const DebugMenu() : null,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: ModalRoute.of(context)?.animation ??
                  AlwaysStoppedAnimation(1.0),
              curve: Curves.elasticOut,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const InventoryScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      final tween = Tween(begin: begin, end: end);
                      final offsetAnimation = animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.backpack_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ),
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
                          top: size.height * 0.18,
                          child: AnimatedDinoWidget(
                            nature: dinoNature,
                            dinoPet: currentDino,
                            onStageEvolved: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 220),
                    DinoDetailsWidget(
                      nature: dinoNature,
                      typeName: currentDino.type.name,
                      currentStage: currentDino.currentStage.getName,
                    ),

                    SizedBox(height: size.height * 0.03),
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
