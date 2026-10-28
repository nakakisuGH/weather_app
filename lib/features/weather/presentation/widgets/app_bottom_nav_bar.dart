import 'package:flutter/material.dart';

/// Bottom navigation from the design. Only the Locations tab is functional,
/// so it is always the selected one and taps on the other tabs are ignored.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key});

  static const int _locationsIndex = 1;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _locationsIndex,
      onTap: (_) {},
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: 'Locations',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}
