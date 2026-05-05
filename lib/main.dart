import 'package:dinopet_walker/services/app_links_service.dart';
import 'package:dinopet_walker/pages/auth/auth_wrapper.dart';
import 'package:dinopet_walker/services/map/background_tracking_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:dinopet_walker/providers.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  FlutterForegroundTask.initCommunicationPort();

  // Charger les variables dans .env
  await dotenv.load(fileName: "assets/.env");
  await Firebase.initializeApp();

  BackgroundTrackingService.init();

  runApp(
    MultiProvider(
      providers: providers,
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
  final _navigatorKey = GlobalKey<NavigatorState>();
  final AppLinksService _linkService = AppLinksService();

  @override
  void initState() {
    super.initState();
    _linkService.listenIncomingLinks(_navigatorKey);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'DinoPet',
      home: AuthWrapper(),
    );
  }
}
