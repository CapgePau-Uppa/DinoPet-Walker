import 'package:dinopet_walker/widgets/activity_gauge_widget.dart';
import 'package:dinopet_walker/widgets/activity_card.dart';
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

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ActivityController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Mes Activités",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Builder(
        builder: (context) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFC4C02)),
            );
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
              child: Text(
                "Aucune activité trouvée sur votre compte Strava.",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return RefreshIndicator(
            color: const Color(0xFFFC4C02),
            onRefresh: () => controller.loadActivities(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.todayActivities.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ActivityGaugeWidget(
                              title: "Temps d'activité\nSemaine",
                              value: "${controller.totalDuration} min",
                              icon: Icons.timer_outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ActivityGaugeWidget(
                              title: "Distance totale\nSemaine",
                              value:
                                  "${controller.totalDistance.toStringAsFixed(2)} km",
                              icon: Icons.directions_walk,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }

                final activity = controller.todayActivities[index - 1];
                return ActivityCard(activity: activity);
              },
            ),
          );
        },
      ),
    );
  }
}
