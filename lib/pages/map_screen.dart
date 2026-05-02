import 'package:dinopet_walker/controllers/map_screen_controller.dart';
import 'package:dinopet_walker/pages/map_permission_screen.dart';
import 'package:dinopet_walker/widgets/map/other_user.dart';
import 'package:dinopet_walker/widgets/map/gradient_path.dart';
import 'package:dinopet_walker/widgets/map/permission_warning_icon.dart';
import 'package:dinopet_walker/widgets/map/user_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_foreground_task/ui/with_foreground_task.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:dinopet_walker/widgets/common/toast.dart';
import 'package:app_settings/app_settings.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  final MapController _flutterMapController = MapController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _init();
      context.read<MapScreenController>().refreshWarningPermissions();
    }
  }

  Future<void> _init({bool showToast = false}) async {
    final controller = context.read<MapScreenController>();

    if (controller.userPosition == null) {
      setState(() => _loading = true);
    }

    final error = await controller.init();

    if (!mounted) return;

    setState(() => _loading = false);

    if (error != null && showToast) {
      Toast.show(
        context: context,
        message: error,
        icon: Icons.location_off,
        color: const Color(0xFFC94A4A),
      );
    }
  }

  void _openSettings() {
    AppSettings.openAppSettings(type: AppSettingsType.location);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MapScreenController>();

    if (_loading || controller.status == MapStatus.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (controller.status == MapStatus.error || controller.locationDenied) {
      return MapPermissionScreen(
        isPermanentlyDenied: true,
        onRetry: _openSettings,
      );
    }

    return WithForegroundTask(
      child: Scaffold(
        body: Stack(
          children: [
            FlutterMap(
              mapController: _flutterMapController,
              options: MapOptions(
                initialCenter: controller.userPosition!,
                initialZoom: 16,
                minZoom: 12,
                maxZoom: 19,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.flingAnimation,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://api.maptiler.com/maps/bright/{z}/{x}/{y}.png?key=${dotenv.env['MAPTILER_API_KEY']}',
                  userAgentPackageName: 'com.example.dinopet_walker',
                  tileProvider: NetworkTileProvider(),
                ),
                GradientPath(points: controller.dailyPath),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: controller.userPosition!,
                      width: 60,
                      height: 60,
                      child: const UserMarker(),
                    ),
                    ...controller.otherUsers.map(
                      (user) => Marker(
                        point: LatLng(user.latitude!, user.longitude!),
                        width: 100,
                        height: 70,
                        child: OtherUser(
                          user: user,
                          mapController: _flutterMapController,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const PermissionWarningIcon(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (controller.userPosition != null) {
              _flutterMapController.move(controller.userPosition!, 19);
            }
          },
          backgroundColor: const Color(0xFF004D40),
          foregroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.my_location),
        ),
      ),
    );
  }
}