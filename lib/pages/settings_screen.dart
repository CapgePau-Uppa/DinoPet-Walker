import 'package:dinopet_walker/widgets/common/toast.dart';
import 'package:dinopet_walker/widgets/login/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:dinopet_walker/controllers/settings_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _loading = false;

  final SettingsController _controller = SettingsController();

  void _signOut() async {
    setState(() => _loading = true);

    final String? error = await _controller.signOut();

    if (!mounted) return;

    setState(() => _loading = false);

    if (error != null) {
      Toast.show(
        context: context,
        message: error,
        icon: Icons.highlight_off,
        color: const Color(0xFFC94A4A),
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthWrapper(logoutToast: true)),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
            onPressed: _loading ? null : _signOut,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    "Se déconnecter",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
