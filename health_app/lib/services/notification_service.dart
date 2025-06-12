import 'dart:async';
import 'dart:math';
import '../models/notification_model.dart';

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // In-memory storage for notifications
  final List<AppNotification> _notifications = [];

  // Stream controller for notification updates
  final _notificationController = StreamController<List<AppNotification>>.broadcast();
  Stream<List<AppNotification>> get notificationsStream => _notificationController.stream;

  // Get all notifications
  List<AppNotification> getAllNotifications() {
    return List.from(_notifications);
  }

  // Get unread notifications count
  int getUnreadCount() {
    return _notifications.where((notification) => !notification.isRead).length;
  }

  // Add a new notification
  void addNotification(AppNotification notification) {
    _notifications.add(notification);
    _notificationController.add(List.from(_notifications));
  }

  // Create and add a new notification
  void createNotification({
    required String title,
    required String message,
    required NotificationType type,
  }) {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(1000).toString(),
      title: title,
      message: message,
      timestamp: DateTime.now(),
      type: type,
    );
    addNotification(notification);
  }

  // Mark a notification as read
  void markAsRead(String id) {
    final index = _notifications.indexWhere((notification) => notification.id == id);
    if (index != -1) {
      final updatedNotification = _notifications[index].copyWith(isRead: true);
      _notifications[index] = updatedNotification;
      _notificationController.add(List.from(_notifications));
    }
  }

  // Mark all notifications as read
  void markAllAsRead() {
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    _notificationController.add(List.from(_notifications));
  }

  // Delete a notification
  void deleteNotification(String id) {
    _notifications.removeWhere((notification) => notification.id == id);
    _notificationController.add(List.from(_notifications));
  }

  // Clear all notifications
  void clearAllNotifications() {
    _notifications.clear();
    _notificationController.add(List.from(_notifications));
  }

  // Add some sample notifications for testing
  void addSampleNotifications() {
    createNotification(
      title: 'Activity Goal Achieved',
      message: 'Congratulations! You\'ve reached your daily step goal of 10,000 steps.',
      type: NotificationType.activity,
    );
    
    createNotification(
      title: 'New Meditation Session',
      message: 'A new guided meditation session "Mindful Morning" is now available.',
      type: NotificationType.meditation,
    );
    
    createNotification(
      title: 'Nutrition Reminder',
      message: 'Don\'t forget to log your lunch for today to stay on track with your nutrition goals.',
      type: NotificationType.nutrition,
    );
    
    createNotification(
      title: 'Achievement Unlocked',
      message: 'You\'ve earned the "Early Bird" badge for completing a workout before 7 AM!',
      type: NotificationType.achievement,
    );
    
    createNotification(
      title: 'Weekly Goal Update',
      message: 'You\'re 80% of the way to your weekly meditation goal. Keep it up!',
      type: NotificationType.goal,
    );
  }
  
  // Dispose method to close the stream controller
  void dispose() {
    _notificationController.close();
  }
}