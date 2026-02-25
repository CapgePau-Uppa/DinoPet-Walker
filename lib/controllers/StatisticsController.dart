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