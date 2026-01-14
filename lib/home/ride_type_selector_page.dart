import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../services/airport/airport_booking_page.dart' as airport;
import '../services/town/town_booking_page.dart' as town;

class RideTypeSelectorPage extends StatelessWidget {
  const RideTypeSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Ride Type"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Town Ride card
            _RideTypeCard(
              icon: Icons.directions_car,
              title: "Town Ride",
              subtitle: "City & local rides",
              color: const Color(0xFFD6EFFF),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => town.TownBookingPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Airport Transfer card
            _RideTypeCard(
              icon: Icons.flight_takeoff,
              title: "Airport Transfer",
              subtitle: "Airport & hotel transfers",
              color: const Color(0xFFFFEBD6),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => airport.AirportBookingPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RideTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _RideTypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        height: 120,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Icon(icon, size: 40, color: ZayroColors.zayroBlue),
            const SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
