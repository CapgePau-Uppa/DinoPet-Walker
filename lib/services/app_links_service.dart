import 'package:app_links/app_links.dart';
import 'package:dinopet_walker/pages/auth/email_change_requires_login_screen.dart';
import 'package:dinopet_walker/pages/auth/email_is_changed_screen.dart';
import 'package:dinopet_walker/services/user_service.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../pages/auth/reset_password_screen.dart';
import '../pages/auth/email_is_verified_screen.dart';

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
    Uri linkUri = uri;

    // Si le lien passe par firebaseapp.com avec link imbriqué
    final innerLink = uri.queryParameters['link'];
    if (innerLink != null) {
      linkUri = Uri.parse(Uri.decodeComponent(innerLink));
    }

    final oobCode = linkUri.queryParameters['oobCode'];
    final mode = linkUri.queryParameters['mode'];

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
      return;
    }

    // mode verifyEmail
    if (mode == 'verifyEmail') {
      try {
        await _authService.verifyEmail(oobCode);
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const EmailIsVerifiedScreen()),
          (route) => false,
        );
      } catch (e) {
        debugPrint('erreur verifyEmail: $e');
      }
      return;
    }

    // mode verifyAndChangeEmail
    if (mode == 'verifyAndChangeEmail') {
      try {
        final uid = _authService.getCurrentUser()?.uid;

        // Si l'utilisateur est déconnecté, on révoque le code et on redirige vers la login
        if (uid == null) {
          await _authService.revokeEmailChange(oobCode);
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => const EmailChangeRequiresLoginScreen(),
            ),
            (route) => false,
          );
          return;
        }

        final newEmail = await _authService.applyEmailChange(
          oobCode: oobCode,
          continueUrlRaw: linkUri.queryParameters['continueUrl'],
        );

        if (newEmail != null) {
          await UserService().updateEmailOnFirestoreByUid(uid, newEmail);
        }

        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const EmailChangedScreen()),
          (route) => false,
        );
      } catch (e) {
        debugPrint('erreur verifyAndChangeEmail: $e');
      }
      return;
    }
  }
}
