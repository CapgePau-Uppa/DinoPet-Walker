import 'package:dinopet_walker/widgets/common/toast.dart';
import 'package:dinopet_walker/widgets/login/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:dinopet_walker/controllers/settings_controller.dart';
import 'package:provider/provider.dart';
import '../controllers/activity_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _loading = false;

  final SettingsController _controller = SettingsController();

  bool _isStravaLinked = false;
  bool _isLoadingStrava = false;

  @override
  void initState() {
    super.initState();
    _checkStravaStatus();
  }

  Future<void> _checkStravaStatus() async {
    final isLinked = await _controller.isStravaLinked();
    if (mounted) {
      setState(() {
        _isStravaLinked = isLinked;
      });
    }
  }

  Future<void> _toggleStravaConnection() async {
    setState(() => _isLoadingStrava = true);

    if (_isStravaLinked) {
      await _controller.unlinkStrava();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Compte Strava déconnecté"),
              backgroundColor: Colors.orange),
        );
        context.read<ActivityController>().loadActivities();
      }
    } else {
      final success = await _controller.linkStrava();
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Compte Strava lié avec succès !"),
                backgroundColor: Colors.green),
          );
          context.read<ActivityController>().loadActivities();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Erreur lors de la connexion à Strava"),
                backgroundColor: Colors.red),
          );
        }
      }
    }

    await _checkStravaStatus();
    if (mounted) setState(() => _isLoadingStrava = false);
  }

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isLoadingStrava ? null : _toggleStravaConnection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isStravaLinked ? Colors.grey[700] : const Color(0xFFFC4C02),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isLoadingStrava
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Icon(_isStravaLinked ? Icons.link_off : Icons.link, color: Colors.white),
                label: Text(
                  _isStravaLinked ? "Déconnecter Strava" : "Lier mon compte Strava",
                  style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 40),

        SizedBox(
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
          ],
      ),
      ),
    );

  }
