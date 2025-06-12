import 'package:flutter/material.dart';

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final NotificationType type;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    required this.type,
  });

  // Create a copy of the notification with updated fields
  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    NotificationType? type,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    );
  }

  // Convert notification to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'isRead': isRead,
      'type': type.toString().split('.').last,
    };
  }

  // Create a notification from a map
  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
      isRead: map['isRead'] ?? false,
      type: NotificationTypeExtension.fromString(map['type'] ?? 'general'),
    );
  }
}

enum NotificationType {
  activity,
  nutrition,
  meditation,
  goal,
  achievement,
  reminder,
  general,
}

extension NotificationTypeExtension on NotificationType {
  static NotificationType fromString(String typeString) {
    return NotificationType.values.firstWhere(
      (type) => type.toString().split('.').last == typeString,
      orElse: () => NotificationType.general,
    );
  }

  String get displayName {
    switch (this) {
      case NotificationType.activity:
        return 'Activity';
      case NotificationType.nutrition:
        return 'Nutrition';
      case NotificationType.meditation:
        return 'Meditation';
      case NotificationType.goal:
        return 'Goal';
      case NotificationType.achievement:
        return 'Achievement';
      case NotificationType.reminder:
        return 'Reminder';
      case NotificationType.general:
        return 'General';
    }
  }
  
  IconData get icon {
    switch (this) {
      case NotificationType.activity:
        return Icons.directions_run;
      case NotificationType.nutrition:
        return Icons.restaurant;
      case NotificationType.meditation:
        return Icons.self_improvement;
      case NotificationType.goal:
        return Icons.flag;
      case NotificationType.achievement:
        return Icons.emoji_events;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.general:
        return Icons.notifications;
    }
  }
}