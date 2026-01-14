import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OsmMap extends StatelessWidget {
  final LatLng? center;
  final List<LatLng> markers;

  const OsmMap({
    super.key,
    required this.center,
    required this.markers,
  });

  @override
  Widget build(BuildContext context) {
    if (center == null) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text("Map unavailable")),
      );
    }

    return FlutterMap(
      options: MapOptions(
        initialCenter: center!,
        initialZoom: 10,
      ),
      children: [
        /// MAP TILES
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: 'com.zayro.app',
        ),

        /// MARKERS
        MarkerLayer(
          markers: markers
              .map(
                (p) => Marker(
                  point: p,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              )
              .toList(),
        ),

        /// ✅ REQUIRED ATTRIBUTION (THIS FIXES BLOCKING)
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              '© OpenStreetMap contributors',
              onTap: () {
                // Optional: open OSM website
              },
            ),
          ],
        ),
      ],
    );
  }
}
