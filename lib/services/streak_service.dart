import 'package:dinopet_walker/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  final UserService _userService = UserService();

  Future<int> checkAndIncrementStreak(int currentSteps, int goalSteps) async {
    final prefs = await SharedPreferences.getInstance();
    final user = await _userService.getCurrentUser();

    int currentStreak = 0;
    String lastDate = '';
    if (prefs.containsKey('streak')) {
      print('premier if');
      currentStreak = prefs.getInt('streak') ?? 0;
      lastDate = prefs.getString('lastStreakUpdate') ?? '';
    }
    else if (user != null && user.streak != null) {
      print('deuxieme if');
      currentStreak = user.streak!;
      lastDate = user.lastStreakUpdate!;
      prefs.setInt('streak', currentStreak);
      prefs.setString('lastStreakUpdate', lastDate);
    }
    print("Current streak: $currentStreak, Last date: $lastDate");

    final today = DateTime.now();
    final todayStr = "${today.year}-${today.month}-${today.day}";

    if (currentSteps < goalSteps || lastDate == todayStr) {
      return await _verifyReset(currentStreak, lastDate);
    }

    return await updateStreak(today, todayStr, lastDate, currentStreak);
  }

  Future<int> updateStreak(DateTime today, String todayStr, String lastDate, int currentStreak) async {
    final prefs = await SharedPreferences.getInstance();

    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayStr = "${yesterday.year}-${yesterday.month}-${yesterday.day}";

    if (lastDate == yesterdayStr) {
      currentStreak++;
    } else {
      currentStreak = 1;
    }

    await prefs.setInt('streak', currentStreak);
    await prefs.setString('lastStreakUpdate', todayStr);

    _userService.updateStreak(currentStreak, todayStr);

    return currentStreak;
  }

  Future<int> _verifyReset(int streak, String lastDate) async {
    if (lastDate.isEmpty || streak == 0) return streak;

    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final todayStr = "${today.year}-${today.month}-${today.day}";
    final yesterdayStr = "${yesterday.year}-${yesterday.month}-${yesterday.day}";

    if (lastDate != todayStr && lastDate != yesterdayStr) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('streak', 0);
      return 0;
    }

    return streak;
  }
}