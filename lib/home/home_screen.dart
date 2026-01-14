import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import 'service_buttons.dart';
import 'quick_actions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Service Buttons Row
          const ServiceButtons(),
          const SizedBox(height: 16),

          // Booking Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ZayroColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Book Your Journey",
                  style: TextStyle(
                    color: ZayroColors.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Pickup Address
                TextField(
                  decoration: InputDecoration(
                    hintText: "Pickup Address",
                    prefixIcon: const Icon(Icons.my_location),
                  ),
                ),
                const SizedBox(height: 12),

                // Drop-off Address
                TextField(
                  decoration: InputDecoration(
                    hintText: "Drop-off Address",
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 16),

                // Get Price Button
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(ZayroColors.zayroBlue),
                    overlayColor:
                        WidgetStateProperty.resolveWith<Color?>((states) {
                      if (states.contains(WidgetState.hovered)) {
                        return ZayroColors.zayroBlue.withOpacity(0.85);
                      }
                      if (states.contains(WidgetState.pressed)) {
                        return ZayroColors.zayroBlue.withOpacity(0.75);
                      }
                      return null;
                    }),
                    shadowColor:
                        WidgetStateProperty.all(Colors.black.withOpacity(0.25)),
                    elevation: WidgetStateProperty.all(6),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      "Get Price",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Quick Actions 2x2
          const QuickActions(),

          const SizedBox(height: 24),

          // Optional: Other content
        ],
      ),
    );
  }
}
