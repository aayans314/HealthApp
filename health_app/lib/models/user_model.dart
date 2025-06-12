class UserProfile {
  final String id;
  final String name;
  final String email;
  final int age;
  final double height; // in cm
  final double weight; // in kg
  final String gender;
  final String profileImageUrl;
  final List<Goal> goals;
  final List<Achievement> achievements;
  final HealthMetrics healthMetrics;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    this.profileImageUrl = '',
    this.goals = const [],
    this.achievements = const [],
    required this.healthMetrics,
  });

  // Create a copy of the user profile with updated fields
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    int? age,
    double? height,
    double? weight,
    String? gender,
    String? profileImageUrl,
    List<Goal>? goals,
    List<Achievement>? achievements,
    HealthMetrics? healthMetrics,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      goals: goals ?? this.goals,
      achievements: achievements ?? this.achievements,
      healthMetrics: healthMetrics ?? this.healthMetrics,
    );
  }

  // Convert user profile to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
      'profileImageUrl': profileImageUrl,
      'goals': goals.map((goal) => goal.toMap()).toList(),
      'achievements': achievements.map((achievement) => achievement.toMap()).toList(),
      'healthMetrics': healthMetrics.toMap(),
    };
  }

  // Create a user profile from a map
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      age: map['age'] ?? 0,
      height: map['height'] ?? 0.0,
      weight: map['weight'] ?? 0.0,
      gender: map['gender'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      goals: map['goals'] != null
          ? List<Goal>.from(map['goals']?.map((x) => Goal.fromMap(x)))
          : [],
      achievements: map['achievements'] != null
          ? List<Achievement>.from(
              map['achievements']?.map((x) => Achievement.fromMap(x)))
          : [],
      healthMetrics: map['healthMetrics'] != null
          ? HealthMetrics.fromMap(map['healthMetrics'])
          : HealthMetrics(
              heartRate: 0,
              bloodPressureSystolic: 0,
              bloodPressureDiastolic: 0,
              sleepHours: 0,
              bmi: 0,
            ),
    );
  }

  // Calculate BMI
  double calculateBMI() {
    if (height <= 0) return 0;
    return weight / ((height / 100) * (height / 100));
  }

  // Get BMI category
  String getBMICategory() {
    final bmi = calculateBMI();
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }
}

class Goal {
  final String id;
  final String title;
  final String description;
  final DateTime targetDate;
  final bool isCompleted;
  final String category; // e.g., 'fitness', 'nutrition', 'meditation'
  final int progress; // 0-100 percentage

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.targetDate,
    this.isCompleted = false,
    required this.category,
    this.progress = 0,
  });

  // Create a copy of the goal with updated fields
  Goal copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? targetDate,
    bool? isCompleted,
    String? category,
    int? progress,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetDate: targetDate ?? this.targetDate,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      progress: progress ?? this.progress,
    );
  }

  // Convert goal to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetDate': targetDate.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
      'category': category,
      'progress': progress,
    };
  }

  // Create a goal from a map
  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      targetDate: map['targetDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['targetDate'])
          : DateTime.now(),
      isCompleted: map['isCompleted'] ?? false,
      category: map['category'] ?? '',
      progress: map['progress'] ?? 0,
    );
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final DateTime dateAchieved;
  final String iconUrl;
  final String category; // e.g., 'fitness', 'nutrition', 'meditation'

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.dateAchieved,
    this.iconUrl = '',
    required this.category,
  });

  // Convert achievement to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateAchieved': dateAchieved.millisecondsSinceEpoch,
      'iconUrl': iconUrl,
      'category': category,
    };
  }

  // Create an achievement from a map
  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dateAchieved: map['dateAchieved'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateAchieved'])
          : DateTime.now(),
      iconUrl: map['iconUrl'] ?? '',
      category: map['category'] ?? '',
    );
  }
}

class HealthMetrics {
  final int heartRate; // beats per minute
  final int bloodPressureSystolic; // mmHg
  final int bloodPressureDiastolic; // mmHg
  final double sleepHours; // hours
  final double bmi; // body mass index

  HealthMetrics({
    required this.heartRate,
    required this.bloodPressureSystolic,
    required this.bloodPressureDiastolic,
    required this.sleepHours,
    required this.bmi,
  });

  // Convert health metrics to a map
  Map<String, dynamic> toMap() {
    return {
      'heartRate': heartRate,
      'bloodPressureSystolic': bloodPressureSystolic,
      'bloodPressureDiastolic': bloodPressureDiastolic,
      'sleepHours': sleepHours,
      'bmi': bmi,
    };
  }

  // Create health metrics from a map
  factory HealthMetrics.fromMap(Map<String, dynamic> map) {
    return HealthMetrics(
      heartRate: map['heartRate'] ?? 0,
      bloodPressureSystolic: map['bloodPressureSystolic'] ?? 0,
      bloodPressureDiastolic: map['bloodPressureDiastolic'] ?? 0,
      sleepHours: map['sleepHours'] ?? 0.0,
      bmi: map['bmi'] ?? 0.0,
    );
  }
}