import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = NotificationService();
  late List<AppNotification> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = _notificationService.getAllNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.notifications),
        actions: [
          if (_notifications.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'mark_all_read') {
                  _notificationService.markAllAsRead();
                  setState(() {
                    _notifications = _notificationService.getAllNotifications();
                  });
                } else if (value == 'clear_all') {
                  _showClearConfirmationDialog();
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'mark_all_read',
                  child: Text('Mark all as read'),
                ),
                const PopupMenuItem<String>(
                  value: 'clear_all',
                  child: Text('Clear all'),
                ),
              ],
            ),
        ],
      ),
      body: StreamBuilder<List<AppNotification>>(
        stream: _notificationService.notificationsStream,
        initialData: _notifications,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final notifications = snapshot.data!;
            _notifications = notifications;
            
            if (notifications.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      size: 64,
                      color: AppTheme.textSecondaryColor,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No notifications yet',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }
            
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _buildNotificationItem(notification);
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add sample notifications for testing
          _notificationService.addSampleNotifications();
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNotificationItem(AppNotification notification) {
    return Dismissible(
      key: Key(notification.id),
      background: Container(
        color: AppTheme.errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        _notificationService.deleteNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notification deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                _notificationService.addNotification(notification);
              },
            ),
          ),
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: notification.isRead
              ? AppTheme.primaryColor.withOpacity(0.2)
              : AppTheme.primaryColor,
          child: Icon(
            notification.type.icon,
            color: notification.isRead
                ? AppTheme.primaryColor
                : Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification.message),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(notification.timestamp),
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          if (!notification.isRead) {
            _notificationService.markAsRead(notification.id);
          }
          _showNotificationDetailsDialog(notification);
        },
      ),
    );
  }

  void _showNotificationDetailsDialog(AppNotification notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              notification.type.icon,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                notification.title,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 16),
            Text(
              'Type: ${notification.type.displayName}',
              style: const TextStyle(color: AppTheme.textSecondaryColor),
            ),
            const SizedBox(height: 4),
            Text(
              'Received: ${_formatTimestamp(notification.timestamp)}',
              style: const TextStyle(color: AppTheme.textSecondaryColor),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              _notificationService.deleteNotification(notification.id);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all notifications?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _notificationService.clearAllNotifications();
              Navigator.of(context).pop();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}