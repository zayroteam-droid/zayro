import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import 'footer/bottom_navigation.dart';
import 'header/top_bar.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  // Pages for each tab
  final List<Widget> _pages = const [
    HomeScreen(),
    Center(child: Text("Rides Page")),    // Placeholder
    Center(child: Text("Account Page")),  // Placeholder
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),           // Top bar with Zayro, Manchester, Notifications
      body: _pages[_currentIndex],      // Current page
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,    // Current tab
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
