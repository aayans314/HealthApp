import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../utils/theme.dart';
import '../models/notification_model.dart';

class NotificationBadge extends StatelessWidget {
  final NotificationService notificationService;
  final double size;
  
  const NotificationBadge({
    super.key,
    required this.notificationService,
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AppNotification>>(
      stream: notificationService.notificationsStream,
      builder: (context, snapshot) {
        final unreadCount = notificationService.getUnreadCount();
        
        if (unreadCount == 0) {
          return const SizedBox.shrink();
        }
        
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppTheme.errorColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              unreadCount > 9 ? '9+' : unreadCount.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.6,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}