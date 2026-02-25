import 'package:flutter/material.dart';

class InteractiveChartWidget extends StatelessWidget {
  final List<int?> weekData;
  final DateTime weekStartDate;
  final DateTime selectedDate;
  final Function(DateTime) onDaySelected;

  const InteractiveChartWidget({
    super.key,
    required this.weekData,
    required this.weekStartDate,
    required this.selectedDate,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              DateTime currentBarDate = weekStartDate.add(Duration(days: index));
              bool isSelected = _isSameDay(currentBarDate, selectedDate);
              int? steps = weekData[index];

              return GestureDetector(
                onTap: () => onDaySelected(currentBarDate),
                child: _buildChartBar(steps, isSelected),
              );
            }),
          ),
          const SizedBox(height: 8),
          Container(height: 1, width: double.infinity, color: Colors.black),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ChartLabel("L"), _ChartLabel("M"), _ChartLabel("M"), _ChartLabel("J"),
              _ChartLabel("V"), _ChartLabel("S"), _ChartLabel("D"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildChartBar(int? steps, bool isSelected) {
    const double barWidth = 24.0;
    const double totalHeight = 120.0;

    if (steps == null || steps == 0) {
      return Container(
        width: barWidth,
        height: totalHeight,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
        ),
      );
    }

    double fillPercentage = (steps / 10000).clamp(0.0, 1.0);
    double barHeight = totalHeight * fillPercentage;
    if (barHeight < 10) barHeight = 10;

    Color barColor = const Color(0xFF4CAF50);
    if (steps < 4000) barColor = const Color(0xFFF0723A);
    else if (steps < 8000) barColor = const Color(0xFFFFEA00);

    return Opacity(
      opacity: isSelected ? 1.0 : 0.4,
      child: Container(
        width: barWidth,
        height: totalHeight,
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
        ),
        child: Container(
          height: barHeight,
          width: barWidth,
          color: barColor,
        ),
      ),
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
      width: 24,
      child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }
}