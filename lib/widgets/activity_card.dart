import 'package:dinopet_walker/models/sport_activity.dart';
import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final SportActivity activity;

  const ActivityCard({super.key, required this.activity});

  IconData _getIconForSport(String sportName) {
    switch (sportName) {
      case 'Marche':
        return Icons.directions_walk;
      case 'Course à pied':
        return Icons.directions_run;
      case 'Vélo':
      case 'VTT':
        return Icons.directions_bike;
      case 'Natation':
        return Icons.pool;
      case 'Randonnée':
        return Icons.hiking;
      case 'HIIT':
        return Icons.fitness_center;
      case 'Pilates':
      case 'Yoga':
        return Icons.self_improvement;
      case 'Ski':
        return Icons.snowboarding;
      case 'Snowboard':
        return Icons.downhill_skiing;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {

    bool hasDistance=false;

    if(activity.distanceInKm > 0){
      hasDistance = activity.distanceInKm > 0;
    }

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
            child: Icon(
              _getIconForSport(activity.sportName),
              color: const Color(0xFFFC4C02),
              size: 30,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.sportName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
              if (hasDistance)
                Text(
                  "${activity.distanceInKm.toStringAsFixed(2)} km",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              Text(
                "${activity.durationInMinutes} min",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
