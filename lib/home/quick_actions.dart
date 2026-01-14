import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../services/airport/airport_booking_page.dart';
import '../services/parcel/courier_booking_page.dart'; // <-- ParcelPickupPage
import '../services/delivery/delivery_booking_page.dart';
import '../services/event/event_bus_booking_page.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'icon': Icons.airplanemode_active,
        'label': 'Airport',
        'color': const Color(0xFFD6EFFF),
        'page': const AirportBookingPage(),
      },
      {
        'icon': Icons.local_shipping,
        'label': 'SameDay Parcel',
        'color': const Color(0xFFDFFFE2),
        'page': const ParcelPickupPage(), // <-- Correct class
      },
      {
        'icon': Icons.local_shipping,
        'label': 'Express Van',
        'color': const Color(0xFFEDE6FF),
        'page': const DeliveryBookingPage(),
      },
      {
        'icon': Icons.event,
        'label': 'Event',
        'color': const Color(0xFFFFEBD6),
        'page': const EventBusBookingPage(),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ZayroColors.primaryText,
            shadows: [
              Shadow(
                offset: const Offset(0, 1),
                blurRadius: 2,
                color: Colors.black.withValues(alpha: 0.2), // <-- fixed deprecation
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: QuickActionButton(data: actions[0])),
            const SizedBox(width: 12),
            Expanded(child: QuickActionButton(data: actions[1])),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: QuickActionButton(data: actions[2])),
            const SizedBox(width: 12),
            Expanded(child: QuickActionButton(data: actions[3])),
          ],
        ),
      ],
    );
  }
}

class QuickActionButton extends StatelessWidget {
  final Map<String, dynamic> data;
  const QuickActionButton({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ElevatedButton(
        onPressed: () {
          final page = data['page'] as Widget?;
          if (page != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => page),
            );
          }
        },
        style: ButtonStyle(
  backgroundColor: WidgetStateProperty.all(data['color'] as Color),
  overlayColor: WidgetStateProperty.resolveWith((states) {
    final c = data['color'] as Color;
    if (states.contains(WidgetState.hovered)) {
      return c.withValues(alpha: 0.8);
    }
    if (states.contains(WidgetState.pressed) ||
        states.contains(WidgetState.focused)) {
      return c.withValues(alpha: 0.7);
    }
    return null;
  }),
  shadowColor: WidgetStateProperty.all(Colors.black.withValues(alpha: 0.05)),
  elevation: WidgetStateProperty.all(2),
  shape: WidgetStateProperty.all(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              data['icon'] as IconData,
              color: ZayroColors.zayroBlue,
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              data['label'] as String,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ZayroColors.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
