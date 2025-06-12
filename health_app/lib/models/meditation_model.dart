class MeditationSession {
  final String id;
  final String userId;
  final String title;
  final String category; // e.g., 'guided', 'breathing', 'sleep', 'mindfulness'
  final DateTime startTime;
  final DateTime? endTime;
  final int durationInMinutes;
  final bool isCompleted;
  final String? audioUrl;
  final String? imageUrl;
  final String? description;
  final Map<String, dynamic>? additionalData; // For session-specific data

  MeditationSession({
    required this.id,
    required this.userId,
    required this.title,
    required this.category,
    required this.startTime,
    this.endTime,
    required this.durationInMinutes,
    this.isCompleted = false,
    this.audioUrl,
    this.imageUrl,
    this.description,
    this.additionalData,
  });

  // Create a copy of the meditation session with updated fields
  MeditationSession copyWith({
    String? id,
    String? userId,
    String? title,
    String? category,
    DateTime? startTime,
    DateTime? endTime,
    int? durationInMinutes,
    bool? isCompleted,
    String? audioUrl,
    String? imageUrl,
    String? description,
    Map<String, dynamic>? additionalData,
  }) {
    return MeditationSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      category: category ?? this.category,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationInMinutes: durationInMinutes ?? this.durationInMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  // Convert meditation session to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'category': category,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime?.millisecondsSinceEpoch,
      'durationInMinutes': durationInMinutes,
      'isCompleted': isCompleted,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'description': description,
      'additionalData': additionalData,
    };
  }

  // Create a meditation session from a map
  factory MeditationSession.fromMap(Map<String, dynamic> map) {
    return MeditationSession(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      startTime: map['startTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startTime'])
          : DateTime.now(),
      endTime: map['endTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endTime'])
          : null,
      durationInMinutes: map['durationInMinutes'] ?? 0,
      isCompleted: map['isCompleted'] ?? false,
      audioUrl: map['audioUrl'],
      imageUrl: map['imageUrl'],
      description: map['description'],
      additionalData: map['additionalData'],
    );
  }

  // Get remaining time in seconds
  int getRemainingTimeInSeconds() {
    if (isCompleted) return 0;
    
    final now = DateTime.now();
    final endTimeEstimate = startTime.add(Duration(minutes: durationInMinutes));
    
    if (now.isAfter(endTimeEstimate)) return 0;
    
    return endTimeEstimate.difference(now).inSeconds;
  }

  // Get progress percentage (0.0 to 1.0)
  double getProgressPercentage() {
    if (isCompleted) return 1.0;
    
    final now = DateTime.now();
    final totalDurationInSeconds = durationInMinutes * 60;
    final elapsedSeconds = now.difference(startTime).inSeconds;
    
    return (elapsedSeconds / totalDurationInSeconds).clamp(0.0, 1.0);
  }
}

class MeditationProgram {
  final String id;
  final String title;
  final String description;
  final String category; // e.g., 'beginner', 'stress', 'sleep', 'focus'
  final int durationInDays;
  final List<MeditationSession> sessions;
  final String? imageUrl;
  final String? instructorName;
  final int totalMinutes; // Total minutes across all sessions

  MeditationProgram({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.durationInDays,
    required this.sessions,
    this.imageUrl,
    this.instructorName,
    required this.totalMinutes,
  });

  // Convert meditation program to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'durationInDays': durationInDays,
      'sessions': sessions.map((session) => session.toMap()).toList(),
      'imageUrl': imageUrl,
      'instructorName': instructorName,
      'totalMinutes': totalMinutes,
    };
  }

  // Create a meditation program from a map
  factory MeditationProgram.fromMap(Map<String, dynamic> map) {
    return MeditationProgram(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      durationInDays: map['durationInDays'] ?? 0,
      sessions: map['sessions'] != null
          ? List<MeditationSession>.from(
              map['sessions']?.map((x) => MeditationSession.fromMap(x)))
          : [],
      imageUrl: map['imageUrl'],
      instructorName: map['instructorName'],
      totalMinutes: map['totalMinutes'] ?? 0,
    );
  }

  // Calculate completion percentage
  double getCompletionPercentage(String userId) {
    if (sessions.isEmpty) return 0.0;
    
    final userSessions = sessions.where((session) => session.userId == userId).toList();
    if (userSessions.isEmpty) return 0.0;
    
    final completedSessions = userSessions.where((session) => session.isCompleted).length;
    return completedSessions / userSessions.length;
  }
}

class MeditationSummary {
  final String userId;
  final DateTime date;
  final int totalMinutes;
  final int sessionsCompleted;
  final Map<String, int> categoryMinutes; // e.g., {'guided': 15, 'breathing': 10}
  final int currentStreak; // Consecutive days of meditation

  MeditationSummary({
    required this.userId,
    required this.date,
    required this.totalMinutes,
    required this.sessionsCompleted,
    required this.categoryMinutes,
    required this.currentStreak,
  });

  // Convert meditation summary to a map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': date.millisecondsSinceEpoch,
      'totalMinutes': totalMinutes,
      'sessionsCompleted': sessionsCompleted,
      'categoryMinutes': categoryMinutes,
      'currentStreak': currentStreak,
    };
  }

  // Create a meditation summary from a map
  factory MeditationSummary.fromMap(Map<String, dynamic> map) {
    return MeditationSummary(
      userId: map['userId'] ?? '',
      date: map['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['date'])
          : DateTime.now(),
      totalMinutes: map['totalMinutes'] ?? 0,
      sessionsCompleted: map['sessionsCompleted'] ?? 0,
      categoryMinutes: map['categoryMinutes'] != null
          ? Map<String, int>.from(map['categoryMinutes'])
          : {},
      currentStreak: map['currentStreak'] ?? 0,
    );
  }

  // Check if daily meditation goal is achieved (default: 10 minutes)
  bool isMeditationGoalAchieved({int minutesGoal = 10}) {
    return totalMinutes >= minutesGoal;
  }

  // Calculate meditation goal progress percentage
  double getMeditationGoalProgress({int minutesGoal = 10}) {
    return (totalMinutes / minutesGoal).clamp(0.0, 1.0);
  }
}