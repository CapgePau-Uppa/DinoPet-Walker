import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../pages/reset_password_screen.dart';
import '../pages/email_is_verified_screen.dart';

class AppLinksService {
  final _appLinks = AppLinks();
  final AuthService _authService = AuthService();

  void listenIncomingLinks(GlobalKey<NavigatorState> navigatorKey) async {
    // L'app été fermée et donc c'est android qui passe le lien a l'app
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) _handleLink(initialLink, navigatorKey);

    // Écouter si l'app est en arrière plan
    _appLinks.uriLinkStream.listen((uri) => _handleLink(uri, navigatorKey));
  }

  // Gérer les liens ouverts au niveau de l'app
  void _handleLink(Uri uri, GlobalKey<NavigatorState> navigatorKey) async {
    final oobCode = uri.queryParameters['oobCode'];
    final mode = uri.queryParameters['mode'];

    if (oobCode == null) return;

    final context = navigatorKey.currentState?.context;
    if (context == null) return;

    // mode resetPassword
    if (mode == 'resetPassword') {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(oobCode: oobCode),
        ),
      );
    } 

    // mode verifyEmail
    if (mode == 'verifyEmail') {
      try {
        await _authService.verifyEmail(oobCode);
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => const EmailIsVerifiedScreen()),
        );
      } catch (e) {
        //
      }
    }
  }
}
