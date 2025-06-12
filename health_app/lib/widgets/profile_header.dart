import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../utils/theme.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile userProfile;

  const ProfileHeader({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor.withOpacity(0.7),
              ],
            ),
          ),
        ),
        // Pattern overlay
        Opacity(
          opacity: 0.1,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://via.placeholder.com/500'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // User info
        Positioned(
          bottom: 60,
          left: 20,
          right: 20,
          child: Row(
            children: [
              // Profile image
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 38,
                  backgroundImage: NetworkImage(
                    userProfile.profileImageUrl.isNotEmpty
                        ? userProfile.profileImageUrl
                        : 'https://via.placeholder.com/150',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // User details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProfile.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${userProfile.age} years • ${userProfile.gender}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Stats summary
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 50,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('Height', '${userProfile.height} cm'),
                _buildVerticalDivider(),
                _buildStatItem('Weight', '${userProfile.weight} kg'),
                _buildVerticalDivider(),
                _buildStatItem('BMI', userProfile.calculateBMI().toStringAsFixed(1)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }
}