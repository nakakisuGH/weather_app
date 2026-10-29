import 'package:flutter/material.dart';
import 'package:weather_app/core/theme/app_colors.dart';

/// Bottom navigation from the design. Only the Locations tab is functional,
/// so it is always the selected one and taps on the other tabs are ignored.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key});

  static const int _locationsIndex = 1;

  /// Same space on every side, so the icons sit closer to the center.
  static const double _padding = 5;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.divider, width: 1.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(_padding),
        child: BottomNavigationBar(
          currentIndex: _locationsIndex,
          onTap: (_) {},
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined),
              label: 'Locations',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
