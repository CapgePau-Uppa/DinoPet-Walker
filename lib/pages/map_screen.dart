import 'package:app_settings/app_settings.dart';
import 'package:dinopet_walker/controllers/map_screen_controller.dart';
import 'package:dinopet_walker/widgets/common/primary_button.dart';
import 'package:dinopet_walker/widgets/user_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:dinopet_walker/widgets/common/toast.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _flutterMapController = MapController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    setState(() => _loading = true);

    final error = await context.read<MapScreenController>().init();

    if (!mounted) return;
    setState(() => _loading = false);

    if (error != null) {
      Toast.show(
        context: context,
        message: error,
        icon: Icons.location_off,
        color: const Color(0xFFC94A4A),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MapScreenController>();

    if (_loading || controller.status == MapStatus.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (controller.status == MapStatus.error) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F9FB),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_off_rounded,
                        size: 70,
                        color: Color(0xFF2E7D32),
                      ),
                    ),

                    const SizedBox(height: 40),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 28,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Oups ! Localisation introuvable',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2D3436),
                            ),
                          ),

                          const SizedBox(height: 16),

                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                height: 1.5,
                              ),
                              children: [
                                const TextSpan(
                                  text:
                                      "Nous n'arrivons pas a vous localiser.\n",
                                ),
                                const TextSpan(text: "Assurez vous que le "),
                                const TextSpan(
                                  text: "GPS est activé",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const TextSpan(text: " et que "),
                                const TextSpan(
                                  text: "l'accès est autorisé",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const TextSpan(
                                  text: " pour cette application.",
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          PrimaryButton(
                            label: 'Réessayer',
                            onPressed: _init,
                            width: double.infinity,
                          ),

                          const SizedBox(height: 12),

                          TextButton.icon(
                            onPressed: () {
                              AppSettings.openAppSettings(
                                type: AppSettingsType.location,
                              );
                            },
                            icon: const Icon(
                              Icons.settings_outlined,
                              size: 20,
                              color: Colors.blueGrey,
                            ),
                            label: const Text(
                              "Paramètres de l'appareil",
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: FlutterMap(
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
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.dinopet_walker',
            tileProvider: NetworkTileProvider(),
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: controller.dailyPath,
                strokeWidth: 4.0,
                color: const Color(0xFF00897B),
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: controller.userPosition!,
                width: 60,
                height: 60,
                child: const UserMarker(),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _flutterMapController.move(controller.userPosition!, 19),
        backgroundColor: const Color(0xFF004D40),
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
