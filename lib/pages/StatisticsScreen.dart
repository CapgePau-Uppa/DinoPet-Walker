import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/HomeController.dart';
import '../controllers/StatisticsController.dart';

import '../widgets/statistics/DateBadgeWidget.dart';
import '../widgets/statistics/DailyStatsWidget.dart';
import '../widgets/statistics/AverageCardWidget.dart';
import '../widgets/statistics/InteractiveChartWidget.dart';
import '../widgets/statistics/ChartNavigationWidget.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatistiquesScreenState();
}

class _StatistiquesScreenState extends State<StatisticsScreen> {
  @override
  void initState() {
    super.initState();

    // Au lancement de la page, on charge les données de la semaine en cours
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final liveSteps = context.read<HomeController>().currentSteps;
      context.read<StatisticsController>().loadStats(liveSteps);
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeController = context.watch<HomeController>();
    final statController = context.watch<StatisticsController>();

    final int liveSteps = homeController.currentSteps;
    final DateTime now = DateTime.now();

    final bool isSelectedToday = statController.selectedDate.year == now.year &&
        statController.selectedDate.month == now.month &&
        statController.selectedDate.day == now.day;

    final int displaySteps = isSelectedToday ? liveSteps : statController.selectedSteps;

    List<int?> dynamicWeekData = List.from(statController.weekStepsData);
    for (int i = 0; i < 7; i++) {
      DateTime day = statController.currentWeekStart.add(Duration(days: i));
      if (day.year == now.year && day.month == now.month && day.day == now.day) {
        dynamicWeekData[i] = liveSteps;
      }
    }

    final DateTime sDate = statController.selectedDate;
    final String formattedDate = "${sDate.day.toString().padLeft(2, '0')}/${sDate.month.toString().padLeft(2, '0')}/${sDate.year}";

    final double distanceInKm = (displaySteps * 0.75) / 1000;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: statController.isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF4CAF50)))
            : SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              DateBadgeWidget(date: formattedDate),
              const SizedBox(height: 30),

              DailyStatsWidget(
                steps: displaySteps,
                distance: "${distanceInKm.toStringAsFixed(2)} Km",
                percentage: statController.percentageComparedToYesterday,
                isUp: statController.isUpComparedToYesterday,
              ),
              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: AverageCardWidget(
                        title: "Moyenne\nHebdomadaire",
                        steps: statController.weeklyAverage,
                        percentage: statController.weeklyPercentage,
                        subtitle: "par rapport à la\ndernière semaine",
                        isUp: statController.isWeeklyUp,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AverageCardWidget(
                        title: "Moyenne\nMensuelle",
                        steps: statController.monthlyAverage,
                        percentage: statController.monthlyPercentage,
                        subtitle: "par rapport au\ndernier mois",
                        isUp: statController.isMonthlyUp,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: InteractiveChartWidget(
                  key: ValueKey<String>(statController.currentWeekStart.toString()),
                  weekData: dynamicWeekData,
                  weekStartDate: statController.currentWeekStart,
                  selectedDate: statController.selectedDate,
                  onDaySelected: (cliquedDate) {
                    statController.selectDate(cliquedDate, liveSteps);
                  },
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => statController.changeWeek(-1, liveSteps),
                      child: const ChartNavigationWidget(text: "Précédent"),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => statController.changeWeek(1, liveSteps),
                      child: const ChartNavigationWidget(text: "Suivant"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}