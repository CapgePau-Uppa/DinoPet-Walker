import 'package:dinopet_walker/pages/email_verification_screen.dart';
import 'package:dinopet_walker/pages/login_screen.dart';
import 'package:dinopet_walker/pages/selection_screen.dart';
import 'package:dinopet_walker/widgets/common/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatefulWidget {

  final bool logoutToast;
  final bool signupToast;
  
  const AuthWrapper({super.key,this.logoutToast = false,this.signupToast = false,
  });

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {

  @override
  void initState() {
    super.initState();

    if(widget.logoutToast){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Toast.show(
          context: context,
          message: "Déconnecté",
          icon: Icons.check_circle,
          color: const Color(0xFF4CAF50),
        );
      });
    }

    if (widget.signupToast) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Toast.show(
          context: context,
          message: "Inscritpion réussie",
          icon: Icons.check_circle,
          color: const Color(0xFF4CAF50),
        );
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null && !user.emailVerified) {
              return const EmailVerificationScreen();
            }
            return SelectionScreen();
          }
          return LoginScreen();
        },
      ),
    );
  }
}
