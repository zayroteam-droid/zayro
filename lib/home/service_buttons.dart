import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../home/ride_type_selector_page.dart';

// Placeholder imports for other services
import '../services/event/event_bus_booking_page.dart';
import '../services/delivery/delivery_booking_page.dart';
import '../services/parcel/courier_booking_page.dart';

class ServiceButtons extends StatelessWidget {
  const ServiceButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {'icon': Icons.directions_car, 'label': 'Ride'},
      {'icon': Icons.local_shipping, 'label': 'Courier'},
      {'icon': Icons.local_shipping, 'label': 'Van'},
      {'icon': Icons.airline_seat_recline_extra, 'label': 'Coach'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: services.map((service) {
        final label = service['label'] as String;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ElevatedButton(
              onPressed: () {
                if (label == 'Ride') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RideTypeSelectorPage()),
                  );
                } 
                else if (label == 'Courier') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ParcelPickupPage()), // TODO: create this page
                  );
                } 
                else if (label == 'Van') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DeliveryBookingPage()), // TODO: create this page
                  );
                } 
                else if (label == 'Coach') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EventBusBookingPage()), // TODO: create this page
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(ZayroColors.cardBackground),
                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) {
                    if (states.contains(WidgetState.hovered)) {
                      return ZayroColors.zayroBlue.withValues(alpha: 26);
                    }
                    return null;
                  },
                ),
                shadowColor: WidgetStateProperty.all(Colors.black.withValues(alpha: 26)),
                elevation: WidgetStateProperty.all(2),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    service['icon'] as IconData,
                    color: ZayroColors.zayroBlue,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service['label'] as String,
                    style: TextStyle(
                      color: ZayroColors.primaryText,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
