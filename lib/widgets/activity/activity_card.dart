import 'package:dinopet_walker/models/activity/sport_activity.dart';
import 'package:dinopet_walker/utils/activity_helper.dart';
import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final SportActivity activity;

  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {

    bool hasDistance=false;

    final String sportName = ActivityHelper.getSportName(activity.type);
    final IconData sportIcon = ActivityHelper.getIconForSport(sportName);

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
              sportIcon,
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
                  sportName,
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
