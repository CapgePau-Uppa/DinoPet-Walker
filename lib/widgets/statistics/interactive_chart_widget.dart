import 'package:flutter/material.dart';

class InteractiveChartWidget extends StatelessWidget {
  final bool isStravaLinked;

  final List<int?> weekStepsData;
  final List<int?> weekTimeData;
  final List<double?> weekDistanceData;

  final int goalSteps;
  final int goalTime;
  final int goalDistance;

  final DateTime weekStartDate;
  final DateTime selectedDate;
  final Function(DateTime) onDaySelected;

  const InteractiveChartWidget({
    super.key,
    required this.isStravaLinked,
    required this.weekStepsData,
    required this.weekTimeData,
    required this.weekDistanceData,
    required this.goalSteps,
    required this.goalTime,
    required this.goalDistance,
    required this.weekStartDate,
    required this.selectedDate,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              DateTime currentBarDate = weekStartDate.add(
                Duration(days: index),
              );
              bool isSelected = _isSameDay(currentBarDate, selectedDate);

              int? steps = weekStepsData[index];
              int? time = weekTimeData[index];
              double? distance = weekDistanceData[index];

              return GestureDetector(
                onTap: () => onDaySelected(currentBarDate),
                child: _buildStackedChartBar(steps, time, distance, isSelected),
              );
            }),
          ),

          const SizedBox(height: 8),
          Container(height: 1, width: double.infinity, color: Colors.black26),
          const SizedBox(height: 8),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ChartLabel("L"),
              _ChartLabel("M"),
              _ChartLabel("M"),
              _ChartLabel("J"),
              _ChartLabel("V"),
              _ChartLabel("S"),
              _ChartLabel("D"),
            ],
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem(const Color(0xFF4A90E2), "Pas"),
              if (isStravaLinked) ...[
                _buildLegendItem(const Color(0xFFF28B30), "Temps"),
                _buildLegendItem(const Color(0xFFD678D2), "Distance"),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStackedChartBar(
    int? steps,
    int? time,
    double? distance,
    bool isSelected,
  ) {
    const double barWidth = 28.0;
    const double totalHeight = 160.0;

    final int segmentsCount = isStravaLinked ? 3 : 1;
    final double segmentMaxHeight = totalHeight / segmentsCount;

    bool hasSteps = steps != null && steps > 0;
    bool hasTime = time != null && time > 0;
    bool hasDist = distance != null && distance > 0;

    bool isEmpty = !hasSteps;
    if (isStravaLinked) {
      isEmpty = isEmpty && !hasTime && !hasDist;
    }

    if (isEmpty) {
      return Container(
        width: barWidth,
        height: totalHeight,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
        ),
      );
    }

    double stepsPct = ((steps ?? 0) / (goalSteps > 0 ? goalSteps : 1)).clamp(
      0.0,
      1.0,
    );
    double timePct = ((time ?? 0) / (goalTime > 0 ? goalTime : 1)).clamp(
      0.0,
      1.0,
    );
    double distPct = ((distance ?? 0) / (goalDistance > 0 ? goalDistance : 1))
        .clamp(0.0, 1.0);

    return Opacity(
      opacity: isSelected ? 1.0 : 0.4,
      child: Container(
        width: barWidth,
        height: totalHeight,
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isStravaLinked) ...[
              Container(
                width: barWidth,
                height: distPct * segmentMaxHeight,
                color: const Color(0xFFD678D2),
              ),
              Container(
                width: barWidth,
                height: timePct * segmentMaxHeight,
                color: const Color(0xFFF28B30),
              ),
            ],
            Container(
              width: barWidth,
              height: stepsPct * segmentMaxHeight,
              color: const Color(0xFF4A90E2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}

class _ChartLabel extends StatelessWidget {
  final String text;
  const _ChartLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
