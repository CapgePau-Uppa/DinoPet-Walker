import 'package:app_links/app_links.dart';
import 'package:dinopet_walker/controllers/DinoController.dart';
import 'package:dinopet_walker/controllers/HomeController.dart';
import 'package:dinopet_walker/controllers/StatisticsController.dart';
import 'package:dinopet_walker/firebase_options.dart';
import 'package:dinopet_walker/pages/ResetPasswordScreen.dart';
import 'package:dinopet_walker/widgets/login/AuthWrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization failed: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DinoController()),
        ChangeNotifierProxyProvider<DinoController, HomeController>(
          create: (ctx) => HomeController(dinoController: ctx.read<DinoController>()),
          update: (ctx, dino, previous) {
            previous!.dinoController = dino;
            return previous;
          }
        ),
        ChangeNotifierProvider(create: (_) => StatisticsController())

      ],
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
  final _appLinks = AppLinks();
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _listenForResetLink();
  }

  void _listenForResetLink() async {
    // l'app été fermée et donc c'est android qui passe le lien a l'app
    final initialLink = await _appLinks.getInitialLink(); 
    if (initialLink != null) _handleLink(initialLink);

    // l'app est ouverte en écoute 
    _appLinks.uriLinkStream.listen(_handleLink);
  }

  void _handleLink(Uri uri) {
    final oobCode = uri.queryParameters['oobCode'];
    final mode = uri.queryParameters['mode']; // mode resetPassword

    if (mode == 'resetPassword' && oobCode != null) {
      _navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(oobCode: oobCode),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey, // ← Important
      debugShowCheckedModeBanner: false,
      title: 'DinoPet',
      home: AuthWrapper(),
    );
  }
}



