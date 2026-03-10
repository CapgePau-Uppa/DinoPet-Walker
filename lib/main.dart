import 'package:app_links/app_links.dart';
import 'package:dinopet_walker/controllers/dino_controller.dart';
import 'package:dinopet_walker/controllers/firestore/user_controller.dart';
import 'package:dinopet_walker/controllers/home_controller.dart';
import 'package:dinopet_walker/controllers/statistics_controller.dart';
import 'package:dinopet_walker/pages/email_is_verified_screen.dart';
import 'package:dinopet_walker/pages/reset_password_screen.dart';
import 'package:dinopet_walker/widgets/login/auth_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
        ChangeNotifierProvider(create: (_) => StatisticsController()),
        ChangeNotifierProvider(create: (_) => UserController()),

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

  // Gérer les liens 
  Future<void> _handleLink(Uri uri) async {
    final oobCode = uri.queryParameters['oobCode'];
    final mode = uri.queryParameters['mode']; 

    // mode resetPassword
    if (mode == 'resetPassword' && oobCode != null) {
      _navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(oobCode: oobCode),
        ),
      );
    }

    // mode verifyEmail
    if (mode == 'verifyEmail' && oobCode != null) {
      try {
        await FirebaseAuth.instance.applyActionCode(oobCode);
        await FirebaseAuth.instance.currentUser?.reload();

        _navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => const EmailIsVerifiedScreen()),
        );
      } catch (e) {
        //
      }
    }
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



