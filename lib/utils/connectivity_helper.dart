import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityHelper {
  static Future<bool> hasInternet() async {
    try {
      final List<ConnectivityResult> result = await Connectivity()
          .checkConnectivity();
      return result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile);
    } catch (e) {
      return false;
    }
  }
}
