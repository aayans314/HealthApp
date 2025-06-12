import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: AppTheme.textSecondaryColor,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: AppConstants.homeLabel,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_run),
              label: AppConstants.activityLabel,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant),
              label: AppConstants.nutritionLabel,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.spa),
              label: AppConstants.meditationLabel,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: AppConstants.profileLabel,
            ),
          ],
        ),
      ),
    );
  }
}