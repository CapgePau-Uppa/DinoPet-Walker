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
      body: () {
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
                  "Vous n'êtes pas connecté a Strava.\nAllez dans les paramètres pour relier votre compte.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: const Color(0xFFFC4C02),
          onRefresh: () => controller.loadActivities(forceRefresh: true),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: ActivityGaugeWidget(
                      title: "Temps d'activité\nHebdomadaire",
                      value: "${controller.totalDuration} min",
                      icon: Icons.timer_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ActivityGaugeWidget(
                      title: "Distance totale\nHebdomadaire",
                      value:
                          "${controller.totalDistance.toStringAsFixed(2)} km",
                      icon: Icons.directions_walk,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (controller.todayActivities.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFC4C02).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFFC4C02).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Color(0xFFFC4C02),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                "Aujourd'hui",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFC4C02),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
              const SizedBox(height: 12),

              if (controller.todayActivities.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text(
                      "Aucune activité aujourd'hui",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                )
              else
                ...controller.todayActivities.map(
                  (activity) => ActivityCard(activity: activity),
                ),
            ],
          ),
        );
      }(),
    );
  }
}
