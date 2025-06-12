class Activity {
  final String id;
  final String userId;
  final String type; // e.g., 'walking', 'running', 'cycling', 'swimming'
  final DateTime startTime;
  final DateTime? endTime;
  final int durationInMinutes;
  final double distance; // in kilometers
  final int steps;
  final int caloriesBurned;
  final double averageHeartRate;
  final Map<String, dynamic>? additionalData; // For activity-specific data

  Activity({
    required this.id,
    required this.userId,
    required this.type,
    required this.startTime,
    this.endTime,
    required this.durationInMinutes,
    required this.distance,
    required this.steps,
    required this.caloriesBurned,
    required this.averageHeartRate,
    this.additionalData,
  });

  // Create a copy of the activity with updated fields
  Activity copyWith({
    String? id,
    String? userId,
    String? type,
    DateTime? startTime,
    DateTime? endTime,
    int? durationInMinutes,
    double? distance,
    int? steps,
    int? caloriesBurned,
    double? averageHeartRate,
    Map<String, dynamic>? additionalData,
  }) {
    return Activity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationInMinutes: durationInMinutes ?? this.durationInMinutes,
      distance: distance ?? this.distance,
      steps: steps ?? this.steps,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      averageHeartRate: averageHeartRate ?? this.averageHeartRate,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  // Convert activity to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime?.millisecondsSinceEpoch,
      'durationInMinutes': durationInMinutes,
      'distance': distance,
      'steps': steps,
      'caloriesBurned': caloriesBurned,
      'averageHeartRate': averageHeartRate,
      'additionalData': additionalData,
    };
  }

  // Create an activity from a map
  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      type: map['type'] ?? '',
      startTime: map['startTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startTime'])
          : DateTime.now(),
      endTime: map['endTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endTime'])
          : null,
      durationInMinutes: map['durationInMinutes'] ?? 0,
      distance: map['distance'] ?? 0.0,
      steps: map['steps'] ?? 0,
      caloriesBurned: map['caloriesBurned'] ?? 0,
      averageHeartRate: map['averageHeartRate'] ?? 0.0,
      additionalData: map['additionalData'],
    );
  }

  // Calculate pace (minutes per kilometer)
  double calculatePace() {
    if (distance <= 0) return 0;
    return durationInMinutes / distance;
  }

  // Format pace as a string (e.g., "5:30 min/km")
  String getPaceFormatted() {
    final pace = calculatePace();
    if (pace <= 0) return '0:00 min/km';
    
    final minutes = pace.floor();
    final seconds = ((pace - minutes) * 60).round();
    return '$minutes:${seconds.toString().padLeft(2, '0')} min/km';
  }

  // Get activity duration formatted as "HH:MM:SS"
  String getDurationFormatted() {
    final hours = (durationInMinutes / 60).floor();
    final minutes = durationInMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:00';
  }
}

class ActivitySummary {
  final String userId;
  final DateTime date;
  final int totalSteps;
  final double totalDistance; // in kilometers
  final int totalCaloriesBurned;
  final int totalActiveMinutes;
  final Map<String, int> activityTypeMinutes; // e.g., {'walking': 30, 'running': 20}

  ActivitySummary({
    required this.userId,
    required this.date,
    required this.totalSteps,
    required this.totalDistance,
    required this.totalCaloriesBurned,
    required this.totalActiveMinutes,
    required this.activityTypeMinutes,
  });

  // Convert activity summary to a map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': date.millisecondsSinceEpoch,
      'totalSteps': totalSteps,
      'totalDistance': totalDistance,
      'totalCaloriesBurned': totalCaloriesBurned,
      'totalActiveMinutes': totalActiveMinutes,
      'activityTypeMinutes': activityTypeMinutes,
    };
  }

  // Create an activity summary from a map
  factory ActivitySummary.fromMap(Map<String, dynamic> map) {
    return ActivitySummary(
      userId: map['userId'] ?? '',
      date: map['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['date'])
          : DateTime.now(),
      totalSteps: map['totalSteps'] ?? 0,
      totalDistance: map['totalDistance'] ?? 0.0,
      totalCaloriesBurned: map['totalCaloriesBurned'] ?? 0,
      totalActiveMinutes: map['totalActiveMinutes'] ?? 0,
      activityTypeMinutes: map['activityTypeMinutes'] != null
          ? Map<String, int>.from(map['activityTypeMinutes'])
          : {},
    );
  }

  // Check if daily step goal is achieved (default: 10,000 steps)
  bool isStepGoalAchieved({int stepGoal = 10000}) {
    return totalSteps >= stepGoal;
  }

  // Calculate step goal progress percentage
  double getStepGoalProgress({int stepGoal = 10000}) {
    return (totalSteps / stepGoal).clamp(0.0, 1.0);
  }
}