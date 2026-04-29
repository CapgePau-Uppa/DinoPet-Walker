import 'package:dinopet_walker/controllers/activity/activity_controller.dart';
import 'package:dinopet_walker/controllers/dino/dino_controller.dart';
import 'package:dinopet_walker/controllers/home_controller.dart';
import 'package:dinopet_walker/controllers/user/user_controller.dart';
import 'package:dinopet_walker/services/permission_service.dart';
import 'package:dinopet_walker/utils/theme_helper.dart';
import 'package:dinopet_walker/widgets/clippers/bowl_clipper.dart';
import 'package:dinopet_walker/widgets/clippers/header_clipper.dart';
import 'package:dinopet_walker/widgets/home/debug_menu.dart';
import 'package:dinopet_walker/widgets/dino/dino_details_widget.dart';
import 'package:dinopet_walker/widgets/dino/animated_dino_widget.dart';
import 'package:dinopet_walker/pages/home_permission_screen.dart';
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

  bool _loading = true;
  bool _activityOk = false;
  bool _healthOk = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initApp());
  }

  Future<void> _initApp() async {
    if (!mounted) return;

    setState(() => _loading = true);

    final statuses = await PermissionService().checkHomePermissions();

    if (!mounted) return;

    if (statuses['activity']! && statuses['health']!) {
      await context.read<UserController>().getCurrentUser();

      if (!mounted) return;
      await context.read<HomeController>().init();

      if (mounted) {
        setState(() {
          _activityOk = true;
          _healthOk = true;
          _loading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _activityOk = statuses['activity']!;
          _healthOk = statuses['health']!;
          _loading = false;
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initApp();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
        ),
      );
    }

    if (!_activityOk || !_healthOk) {
      return HomePermissionScreen(activityOk: _activityOk, healthOk: _healthOk);
    }

    return _buildHomeScreenContent();
  }

  Widget _buildHomeScreenContent() {
    final home = context.watch<HomeController>();
    final dino = context.watch<DinoController>();
    final user = context.watch<UserController>();
    final activity = context.watch<ActivityController>();
    final size = MediaQuery.of(context).size;

    if (dino.dinoPet == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      key: _homeKey,
      backgroundColor: const Color(0xFFF5F7FA),
      endDrawer: kDebugMode ? const DebugMenu() : null,

      body: Stack(
        children: [
          _buildBackground(size, activity.dominantSport),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  UserHeader(
                    username: user.username,
                    userLevel: dino.dinoPet!.level,
                    streak: home.streak,
                  ),

                  const SizedBox(height: 15),

                  _buildDinoStack(
                    size,
                    home,
                    activity.dinoNature,
                    dino.dinoPet,
                  ),

                  SizedBox(height: size.height * 0.35),

                  DinoDetailsWidget(
                    nature: activity.dinoNature,
                    typeName: dino.dinoPet!.type.name,
                    currentStage: dino.dinoPet!.currentStage.getName,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(Size size, dynamic sport) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ClipPath(
            clipper: HeaderClipper(),
            child: Container(height: size.height * 0.38, color: Colors.white),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ClipPath(
            clipper: BowlClipper(),
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              height: size.height * 0.45,
              decoration: ThemeHelper.getBackgroundDecoration(sport),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDinoStack(
    Size size,
    HomeController home,
    dynamic nature,
    dynamic dinoPet,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        GaugeWidget(value: home.currentSteps, maxValue: home.goalSteps),
        Positioned(
          top: size.height * 0.18,
          child: AnimatedDinoWidget(
            nature: nature,
            dinoPet: dinoPet,
            onStageEvolved: () {},
          ),
        ),
      ],
    );
  }
}
