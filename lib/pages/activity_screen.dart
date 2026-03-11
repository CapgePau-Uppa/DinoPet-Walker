import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dinopet_walker/controllers/activity_controller.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActivityController>().loadActivities();
    });
  }

  IconData _getIconForSport(String sportName) {
    switch (sportName) {
      case 'Marche': return Icons.directions_walk;
      case 'Course à pied': return Icons.directions_run;
      case 'Vélo': case 'VTT': return Icons.directions_bike;
      case 'Natation': return Icons.pool;
      case 'Randonnée': return Icons.hiking;
      case 'HIIT': return Icons.fitness_center;
      case 'Pilates': case 'Yoga': return Icons.self_improvement;
      case 'Ski': return Icons.snowboarding;
      case 'Snowboard': return Icons.downhill_skiing;
      default: return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ActivityController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Mes Activités", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: _buildBody(controller),
    );
  }

  Widget _buildBody(ActivityController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFFFC4C02)));
    }

    if (!controller.isStravaLinked) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.link_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              "Strava n'est pas connecté.\nAllez dans les paramètres pour lier votre compte.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (controller.activities.isEmpty) {
      return const Center(
        child: Text("Aucune activité trouvée sur votre compte Strava.", style: TextStyle(color: Colors.grey)),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFFFC4C02),
      onRefresh: () => controller.loadActivities(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.activities.length,
        itemBuilder: (context, index) {
          final activity = controller.activities[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFC4C02).withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_getIconForSport(activity.sportName), color: const Color(0xFFFC4C02), size: 30),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.sportName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activity.formattedDate,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${activity.distanceInKm.toStringAsFixed(2)} km",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${activity.durationInMinutes} min",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}