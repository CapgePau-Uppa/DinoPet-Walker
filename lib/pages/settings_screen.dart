import 'package:dinopet_walker/pages/auth/change_password_screen.dart';
import 'package:dinopet_walker/pages/edit_profile_screen.dart';
import 'package:dinopet_walker/pages/goal_screen.dart';
import 'package:dinopet_walker/widgets/common/toast.dart';
import 'package:dinopet_walker/pages/auth/auth_wrapper.dart';
import 'package:dinopet_walker/widgets/settings/logout_button.dart';
import 'package:dinopet_walker/widgets/settings/settings_item.dart';
import 'package:dinopet_walker/widgets/settings/strava_bottom_sheet.dart';
import 'package:dinopet_walker/widgets/settings/strava_settings_item.dart';
import 'package:flutter/material.dart';
import 'package:dinopet_walker/controllers/settings_controller.dart';
import 'package:provider/provider.dart';
import '../controllers/activity/activity_controller.dart';

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
        Toast.show(
          context: context,
          message: "Compte Strava déconnecté",
          icon: Icons.check_circle,
          color: const Color(0xFF4CAF50),
        );
        context.read<ActivityController>().loadActivities();
      }
    } else {
      final success = await _controller.linkStrava();
      if (mounted) {
        if (success) {
          Toast.show(
            context: context,
            message: "Compte Strava lié avec succès !",
            icon: Icons.check_circle,
            color: const Color(0xFF4CAF50),
          );
          context.read<ActivityController>().loadActivities();
        } else {
          Toast.show(
            context: context,
            message: "Erreur lors de la connexion à Strava",
            icon: Icons.highlight_off,
            color: const Color(0xFFC94A4A),
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
        icon: Icons.wifi_off,
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
    return SingleChildScrollView(
      physics:const BouncingScrollPhysics(), 
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 200), 

            SettingsItem(
              title: "Modifier mon objectif de pas",
              icon: Icons.track_changes,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GoalScreen(goalType: GoalType.steps),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            if (_isStravaLinked) ...[
              SettingsItem(
                title: "Modifier mon objectif de temps",
                icon: Icons.timer,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GoalScreen(goalType: GoalType.time),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),

              SettingsItem(
                title: "Modifier mon objectif de distance",
                icon: Icons.directions_run,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const GoalScreen(goalType: GoalType.distance),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
            ],

            SettingsItem(
              title: "Modifier le profil",
              icon: Icons.manage_accounts_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
            ),

            const SizedBox(height: 15),

            SettingsItem(
              title: "Modifier le mot de passe",
              icon: Icons.lock_clock_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChangePasswordScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            Divider(
              color: const Color(0xFF0B6666).withValues(alpha: .15),
              thickness: 1,
            ),

            const SizedBox(height: 15),

            StravaSettingsItem(
              isLinked: _isStravaLinked,
              onTap: () => StravaBottomSheet.show(
                context,
                isLinked: _isStravaLinked,
                isLoading: _isLoadingStrava,
                onToggle: _toggleStravaConnection,
              ),
            ),

            const SizedBox(height: 40),

            LogoutButton(isLoading: _loading, onTap: _signOut),

            const SizedBox(
              height: 40,
            ), 
          ],
        ),
      ),
    );
  }
}
