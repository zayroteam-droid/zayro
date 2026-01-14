import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // subtle shadow
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Zayro
          Text(
            "Zayro",
            style: TextStyle(
              color: ZayroColors.zayroBlue,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              shadows: const [
                Shadow(
                  color: Colors.black12,
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),

          // Center: Location with map icon
          Row(
            children: [
              Icon(Icons.location_on_outlined,
                  color: ZayroColors.zayroBlue, size: 20),
              const SizedBox(width: 4),
              Text(
                "Manchester, UK",
                style: TextStyle(
                  color: ZayroColors.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Right: Notification icon
          IconButton(
            icon: Icon(Icons.notifications_none, color: ZayroColors.zayroBlue),
            onPressed: () {
              // TODO: Add notification logic
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
