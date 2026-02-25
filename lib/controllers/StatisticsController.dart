import 'package:flutter/material.dart';
import 'package:dinopet_walker/database/dao/DailyStepsDao.dart';
import 'package:dinopet_walker/models/DailySteps.dart';

class StatisticsController extends ChangeNotifier {
  final DailyStepsDao _dailyStepsDao = DailyStepsDao();

  DateTime selectedDate = DateTime.now();
  DateTime currentWeekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

  bool isLoading = true;

  int selectedSteps = 0;
  String percentageComparedToYesterday = "0%";
  bool isUpComparedToYesterday = true;

  List<int?> weekStepsData = List.filled(7, null);

  String weeklyAverage = "0";
  String weeklyPercentage = "0%";
  bool isWeeklyUp = true;

  String monthlyAverage = "0";
  String monthlyPercentage = "0%";
  bool isMonthlyUp = true;

  Future<void> loadStats(int liveStepsToday) async {
    isLoading = true;
    notifyListeners();

    for (int i = 0; i < 7; i++) {
      DateTime day = currentWeekStart.add(Duration(days: i));
      String dateStr = _formatDateForDb(day);

      if (_isSameDay(day, DateTime.now())) {
        weekStepsData[i] = liveStepsToday;
      } else {
        DailySteps? dbData = await _dailyStepsDao.getByDate(dateStr);
        weekStepsData[i] = dbData?.steps;
      }
    }

    await selectDate(selectedDate, liveStepsToday);

    await _calculateAverages(liveStepsToday);

    isLoading = false;
    notifyListeners();
  }

  Future<void> selectDate(DateTime date, int liveStepsToday) async {
    selectedDate = date;

    if (_isSameDay(date, DateTime.now())) {
      selectedSteps = liveStepsToday;
    } else {
      String dateStr = _formatDateForDb(date);
      DailySteps? dbData = await _dailyStepsDao.getByDate(dateStr);
      selectedSteps = dbData?.steps ?? 0;
    }

    String yesterdayStr = _formatDateForDb(date.subtract(const Duration(days: 1)));
    DailySteps? yesterdayData = await _dailyStepsDao.getByDate(yesterdayStr);
    int yesterdaySteps = yesterdayData?.steps ?? 0;

    if (yesterdaySteps == 0) {
      percentageComparedToYesterday = "+ 100%";
      isUpComparedToYesterday = true;
    } else {
      double diff = (selectedSteps - yesterdaySteps) / yesterdaySteps * 100;
      isUpComparedToYesterday = diff >= 0;
      percentageComparedToYesterday = "${isUpComparedToYesterday ? '+' : ''} ${diff.toStringAsFixed(1)}%";
    }

    notifyListeners();
  }

  Future<void> _calculateAverages(int liveStepsToday) async {
    List<DailySteps> history = await _dailyStepsDao.getLastDays(90);

    Map<String, int> stepsByDate = {};
    for (var day in history) {
      stepsByDate[day.date] = day.steps;
    }
    stepsByDate[_formatDateForDb(DateTime.now())] = liveStepsToday;

    // Moyenne hebdomadaire (Basée sur la semaine affichée)
    int currentWeekTotal = 0;
    int previousWeekTotal = 0;

    for (int i = 0; i < 7; i++) {
      currentWeekTotal += stepsByDate[_formatDateForDb(currentWeekStart.add(Duration(days: i)))] ?? 0;
      previousWeekTotal += stepsByDate[_formatDateForDb(currentWeekStart.subtract(Duration(days: 7 - i)))] ?? 0;
    }

    int currentWeekAvg = currentWeekTotal ~/ 7;
    int previousWeekAvg = previousWeekTotal ~/ 7;

    weeklyAverage = currentWeekAvg.toString();
    if (previousWeekAvg == 0) {
      weeklyPercentage = "+ 100%";
      isWeeklyUp = true;
    } else {
      double diff = (currentWeekAvg - previousWeekAvg) / previousWeekAvg * 100;
      isWeeklyUp = diff >= 0;
      weeklyPercentage = "${isWeeklyUp ? '+' : ''} ${diff.toStringAsFixed(1)}%";
    }

    // Moyenne mensuelle (Basée sur les 30 jours précédant le dimanche de la semaine affichée)
    int currentMonthTotal = 0;
    int previousMonthTotal = 0;

    // On prend le dimanche de la semaine affichée comme point de départ
    DateTime endOfDisplayedWeek = currentWeekStart.add(const Duration(days: 6));

    for (int i = 0; i < 30; i++) {
      currentMonthTotal += stepsByDate[_formatDateForDb(endOfDisplayedWeek.subtract(Duration(days: i)))] ?? 0;
      previousMonthTotal += stepsByDate[_formatDateForDb(endOfDisplayedWeek.subtract(Duration(days: i + 30)))] ?? 0;
    }

    int currentMonthAvg = currentMonthTotal ~/ 30;
    int previousMonthAvg = previousMonthTotal ~/ 30;

    monthlyAverage = currentMonthAvg.toString();
    if (previousMonthAvg == 0) {
      monthlyPercentage = "+ 100%";
      isMonthlyUp = true;
    } else {
      double diff = (currentMonthAvg - previousMonthAvg) / previousMonthAvg * 100;
      isMonthlyUp = diff >= 0;
      monthlyPercentage = "${isMonthlyUp ? '+' : ''} ${diff.toStringAsFixed(1)}%";
    }
  }

  void changeWeek(int offsetWeeks, int liveStepsToday) {
    currentWeekStart = currentWeekStart.add(Duration(days: 7 * offsetWeeks));
    selectedDate = currentWeekStart;
    loadStats(liveStepsToday);
  }

  String _formatDateForDb(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}