import 'package:dinopet_walker/controllers/activity/activity_controller.dart';
import 'package:dinopet_walker/controllers/dino/dino_controller.dart';
import 'package:dinopet_walker/controllers/map_screen_controller.dart';
import 'package:dinopet_walker/controllers/user/user_controller.dart';
import 'package:dinopet_walker/controllers/home_controller.dart';
import 'package:dinopet_walker/controllers/statistics_controller.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'controllers/inventory_controller.dart';

List<SingleChildWidget> get providers => [
  ChangeNotifierProvider(create: (_) => DinoController()),

  ChangeNotifierProxyProvider<DinoController, HomeController>(
    create: (ctx) => HomeController(dinoController: ctx.read<DinoController>()),
    update: (ctx, dino, previous) => previous!..dinoController = dino,
  ),
  ChangeNotifierProxyProvider<DinoController, ActivityController>(
    create: (ctx) =>
        ActivityController(dinoController: ctx.read<DinoController>()),
    update: (ctx, dinoController, previous) =>
        previous!..dinoController = dinoController,
  ),

  ChangeNotifierProvider(create: (_) => StatisticsController()),
  ChangeNotifierProvider(create: (_) => UserController()),
  ChangeNotifierProxyProvider<HomeController, MapScreenController>(
    create: (ctx) => MapScreenController(
      currentSteps: ctx.read<HomeController>().currentSteps,
    ),
    update: (ctx, home, previous) => previous!..updateSteps(home.currentSteps),
  ),
  ChangeNotifierProvider(create: (_) => InventoryController()),
  
];
