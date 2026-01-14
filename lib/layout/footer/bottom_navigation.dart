import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

import '../../services/support/support_page.dart';


class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home, 'label': 'Home'},
      {'icon': Icons.list_alt, 'label': 'Activity'},
      {'icon': Icons.support_agent, 'label': 'Support'},
      {'icon': Icons.person, 'label': 'Account'},
    ];

    return Container(
      color: ZayroColors.bottomNavBackground,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isActive = currentIndex == index;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              // update active tab
              onTap(index);

              // Support
              if (index == 2) { // support
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SupportPage(),
      ),
    );
  }
},

             
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item['icon'] as IconData,
                  color: isActive
                      ? ZayroColors.bottomNavActive
                      : ZayroColors.bottomNavInactive,
                  size: 28,
                ),
                const SizedBox(height: 2),
                Text(
                  item['label'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive
                        ? ZayroColors.bottomNavActive
                        : ZayroColors.bottomNavInactive,
                  ),
                ),
                const SizedBox(height: 2),
                if (isActive)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: ZayroColors.bottomNavActive,
                      shape: BoxShape.circle,
                    ),
                  )
                else
                  const SizedBox(height: 6),
              ],
            ),
          );
        }),
      ),
    );
  }
}
