import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:dinopet_walker/models/user/user_model.dart';
import 'package:dinopet_walker/services/auth_service.dart';
import 'package:dinopet_walker/services/map/location_service.dart';
import 'package:dinopet_walker/services/map/tracking_service.dart';
import 'package:dinopet_walker/services/map/location_sharing_service.dart';
import 'package:dinopet_walker/services/map/background_tracking_service.dart';
import 'package:dinopet_walker/services/permission_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:latlong2/latlong.dart';

enum MapStatus { loading, success, error }

class MapScreenController extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final TrackingService _trackingService = TrackingService();
  final AuthService _authService = AuthService();
  final LocationSharingService _locationSharingService = LocationSharingService();
  final PermissionService _permissionService = PermissionService();

  MapStatus _status = MapStatus.loading;
  LatLng? _userPosition;
  List<LatLng> _dailyPath = [];
  List<UserModel> _otherUsers = [];
  int _currentSteps = 0;
  bool _batteryOk = true;
  bool _notifOk = true;
  bool _locationDenied = false;

  StreamSubscription<List<UserModel>>? _otherUsersStream;
  StreamSubscription<User?>? _authStream;

  MapStatus get status => _status;
  LatLng? get userPosition => _userPosition;
  List<LatLng> get dailyPath => List.unmodifiable(_dailyPath);
  List<UserModel> get otherUsers => List.unmodifiable(_otherUsers);
  bool get batteryOk => _batteryOk;
  bool get notifOk => _notifOk;
  bool get hasWarnings => !_batteryOk || !_notifOk;
  bool get locationDenied => _locationDenied;

  MapScreenController({required int currentSteps})
    : _currentSteps = currentSteps {
    // S'il l'utilisateur se déconnecte on libère les streams
    _authStream = _authService.authStateChanges().listen((user) {
      if (user == null) {
        _cancelStreams();
        BackgroundTrackingService.stop();
      }
    });
  }

  Future<String?> init() async {
    if (_status != MapStatus.success) {
      _status = MapStatus.loading;
      notifyListeners();
    }

    await _trackingService.cleanPastDays();

    final (position, error) = await _locationService.getCurrentPosition();

    if (error != null) {
      final result = await _permissionService.checkMapPermissions();
      _locationDenied = !result['location']!;
      _status = MapStatus.error;
      notifyListeners();
      return error;
    }

    _locationDenied = false;
    _userPosition = position;
    _dailyPath = await _trackingService.getTodayTrack();

    _status = MapStatus.success;
    notifyListeners();

    await BackgroundTrackingService.start();

    if (_currentSteps > 0) {
      BackgroundTrackingService.sendStepsToService(_currentSteps);
    }

    _listenServiceData();
    _startWatchingOtherUsers();
    await _checkWarningPermissions();

    return null;
  }

  Future<void> _checkWarningPermissions() async {
    final result = await _permissionService.checkWarningPermissions();
    _batteryOk = result['battery']!;
    _notifOk = result['notification']!;
    notifyListeners();
  }

  Future<void> refreshWarningPermissions() async {
    await _checkWarningPermissions();
  }

  Future<void> requestBattery() async {
    await _permissionService.requestBattery();
    await _checkWarningPermissions();
  }

  void openNotificationSettings() {
    AppSettings.openAppSettings(type: AppSettingsType.notification);
  }

  void _listenServiceData() {
    FlutterForegroundTask.addTaskDataCallback(_onServiceData);
  }

  void _onServiceData(Object data) {
    if (data is Map) {
      final lat = data['lat'] as double?;
      final lng = data['lng'] as double?;
      if (lat != null && lng != null) {
        _userPosition = LatLng(lat, lng);
        _trackingService.getTodayTrack().then((path) {
          _dailyPath = path;
          notifyListeners();
        });
      }
    }
  }


  void _startWatchingOtherUsers() {
    _otherUsersStream?.cancel();
    _otherUsersStream = _locationSharingService.watchOtherUsers().listen((
      users,
    ) {
      _otherUsers = users;
      notifyListeners();
    });
  }

  // Transmettre les steps au service pour qu'il les publie sur Firestore
  void updateSteps(int steps) {
    _currentSteps = steps;
    BackgroundTrackingService.sendStepsToService(steps);
  }

  void _cancelStreams() {
    FlutterForegroundTask.removeTaskDataCallback(_onServiceData);
    _otherUsersStream?.cancel();
    _otherUsersStream = null;
  }

  @override
  void dispose() {
    _cancelStreams();
    _authStream?.cancel();
    super.dispose();
  }
}
