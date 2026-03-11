import 'package:dinopet_walker/controllers/dino_controller.dart';
import 'package:dinopet_walker/controllers/firestore/user_controller.dart';
import 'package:dinopet_walker/controllers/home_controller.dart';
import 'package:dinopet_walker/controllers/statistics_controller.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get providers => [
  ChangeNotifierProvider(create: (_) => DinoController()),

  ChangeNotifierProxyProvider<DinoController, HomeController>(
    create: (ctx) => HomeController(dinoController: ctx.read<DinoController>()),
    update: (ctx, dino, previous) => previous!..dinoController = dino,
  ),

  ChangeNotifierProvider(create: (_) => StatisticsController()),
  ChangeNotifierProvider(create: (_) => UserController()),
];
