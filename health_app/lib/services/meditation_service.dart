import 'dart:async';
import 'dart:math';
import '../models/meditation_model.dart';
import '../utils/constants.dart';

class MeditationService {
  // Singleton pattern
  static final MeditationService _instance = MeditationService._internal();
  factory MeditationService() => _instance;
  MeditationService._internal();

  // In-memory storage for meditation data
  final List<MeditationSession> _sessions = [];
  final List<MeditationProgram> _programs = [];
  MeditationSummary? _currentUserSummary;
  String _currentUserId = 'user123'; // Mock user ID

  // Stream controllers
  final _sessionsController = StreamController<List<MeditationSession>>.broadcast();
  final _programsController = StreamController<List<MeditationProgram>>.broadcast();
  final _summaryController = StreamController<MeditationSummary?>.broadcast();
  final _activeSessionController = StreamController<MeditationSession?>.broadcast();

  // Active session tracking
  MeditationSession? _activeSession;
  Timer? _sessionTimer;
  int _remainingSeconds = 0;

  // Streams
  Stream<List<MeditationSession>> get sessionsStream => _sessionsController.stream;
  Stream<List<MeditationProgram>> get programsStream => _programsController.stream;
  Stream<MeditationSummary?> get summaryStream => _summaryController.stream;
  Stream<MeditationSession?> get activeSessionStream => _activeSessionController.stream;

  // Get all sessions for current user
  List<MeditationSession> getUserSessions() {
    return _sessions.where((session) => session.userId == _currentUserId).toList();
  }

  // Get recent sessions
  List<MeditationSession> getRecentSessions({int limit = 5}) {
    final userSessions = getUserSessions();
    userSessions.sort((a, b) => b.startTime.compareTo(a.startTime));
    return userSessions.take(limit).toList();
  }

  // Get all meditation programs
  List<MeditationProgram> getAllPrograms() {
    return List.from(_programs);
  }

  // Get programs by category
  List<MeditationProgram> getProgramsByCategory(String category) {
    return _programs.where((program) => program.category == category).toList();
  }

  // Get user meditation summary
  MeditationSummary? getUserSummary() {
    return _currentUserSummary;
  }

  // Start a meditation session
  MeditationSession startSession({
    required String title,
    required String category,
    required int durationInMinutes,
    String? audioUrl,
    String? imageUrl,
    String? description,
  }) {
    // End any active session first
    if (_activeSession != null) {
      endSession(completed: false);
    }

    // Create new session
    final session = MeditationSession(
      id: DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(1000).toString(),
      userId: _currentUserId,
      title: title,
      category: category,
      startTime: DateTime.now(),
      durationInMinutes: durationInMinutes,
      audioUrl: audioUrl,
      imageUrl: imageUrl,
      description: description,
    );

    // Set as active session
    _activeSession = session;
    _remainingSeconds = durationInMinutes * 60;

    // Start timer
    _startSessionTimer();

    // Add to sessions list
    _sessions.add(session);
    _sessionsController.add(List.from(_sessions));
    _activeSessionController.add(_activeSession);

    return session;
  }

  // Pause active session
  void pauseSession() {
    if (_activeSession != null && _sessionTimer != null) {
      _sessionTimer!.cancel();
      _sessionTimer = null;
      _activeSessionController.add(_activeSession);
    }
  }

  // Resume active session
  void resumeSession() {
    if (_activeSession != null && _sessionTimer == null) {
      _startSessionTimer();
      _activeSessionController.add(_activeSession);
    }
  }

  // End active session
  MeditationSession? endSession({bool completed = true}) {
    if (_activeSession == null) return null;

    // Cancel timer
    if (_sessionTimer != null) {
      _sessionTimer!.cancel();
      _sessionTimer = null;
    }

    // Update session
    final endTime = DateTime.now();
    final actualDurationInMinutes = endTime.difference(_activeSession!.startTime).inMinutes;
    
    // Update the session in the list
    final index = _sessions.indexWhere((s) => s.id == _activeSession!.id);
    if (index != -1) {
      final updatedSession = _activeSession!.copyWith(
        endTime: endTime,
        isCompleted: completed,
      );
      _sessions[index] = updatedSession;
      _sessionsController.add(List.from(_sessions));

      // Update user summary
      _updateUserSummary(updatedSession, completed ? actualDurationInMinutes : 0);

      // Clear active session
      final completedSession = _activeSession;
      _activeSession = null;
      _activeSessionController.add(null);

      return completedSession;
    }

    return null;
  }

  // Get active session
  MeditationSession? getActiveSession() {
    return _activeSession;
  }

  // Get remaining time for active session (in seconds)
  int getRemainingTime() {
    return _remainingSeconds;
  }

  // Private method to start session timer
  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        _activeSessionController.add(_activeSession);
      } else {
        // Session completed
        endSession(completed: true);
      }
    });
  }

  // Private method to update user summary
  void _updateUserSummary(MeditationSession session, int minutesCompleted) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    if (_currentUserSummary == null || _currentUserSummary!.date.day != todayDate.day) {
      // Create new summary for today
      _currentUserSummary = MeditationSummary(
        userId: _currentUserId,
        date: todayDate,
        totalMinutes: minutesCompleted,
        sessionsCompleted: session.isCompleted ? 1 : 0,
        categoryMinutes: session.isCompleted ? {session.category: minutesCompleted} : {},
        currentStreak: _calculateCurrentStreak(),
      );
    } else {
      // Update existing summary
      final updatedCategoryMinutes = Map<String, int>.from(_currentUserSummary!.categoryMinutes);
      if (session.isCompleted) {
        updatedCategoryMinutes[session.category] = 
            (updatedCategoryMinutes[session.category] ?? 0) + minutesCompleted;
      }

      _currentUserSummary = MeditationSummary(
        userId: _currentUserSummary!.userId,
        date: _currentUserSummary!.date,
        totalMinutes: _currentUserSummary!.totalMinutes + minutesCompleted,
        sessionsCompleted: _currentUserSummary!.sessionsCompleted + (session.isCompleted ? 1 : 0),
        categoryMinutes: updatedCategoryMinutes,
        currentStreak: _calculateCurrentStreak(),
      );
    }

    _summaryController.add(_currentUserSummary);
  }

  // Calculate current streak
  int _calculateCurrentStreak() {
    if (_currentUserSummary == null) return 1;
    
    // For demo purposes, just increment the streak
    // In a real app, this would check previous days' meditation records
    return _currentUserSummary!.currentStreak + 1;
  }

  // Add sample meditation programs
  void addSamplePrograms() {
    // Beginner's program
    final beginnerProgram = MeditationProgram(
      id: '1',
      title: 'Meditation for Beginners',
      description: 'A 7-day program to introduce you to the basics of meditation.',
      category: 'beginner',
      durationInDays: 7,
      sessions: [],
      instructorName: 'Sarah Johnson',
      imageUrl: 'https://via.placeholder.com/400x200',
      totalMinutes: 70,
    );

    // Stress relief program
    final stressProgram = MeditationProgram(
      id: '2',
      title: 'Stress Relief',
      description: 'A 5-day program to help you manage stress and anxiety.',
      category: 'stress',
      durationInDays: 5,
      sessions: [],
      instructorName: 'Michael Chen',
      imageUrl: 'https://via.placeholder.com/400x200',
      totalMinutes: 75,
    );

    // Sleep improvement program
    final sleepProgram = MeditationProgram(
      id: '3',
      title: 'Better Sleep',
      description: 'A 10-day program to improve your sleep quality.',
      category: 'sleep',
      durationInDays: 10,
      sessions: [],
      instructorName: 'Emma Wilson',
      imageUrl: 'https://via.placeholder.com/400x200',
      totalMinutes: 150,
    );

    _programs.addAll([beginnerProgram, stressProgram, sleepProgram]);
    _programsController.add(List.from(_programs));
  }

  // Add sample meditation sessions
  void addSampleSessions() {
    // Sample completed sessions
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
    final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));

    final session1 = MeditationSession(
      id: '1',
      userId: _currentUserId,
      title: 'Morning Mindfulness',
      category: AppConstants.mindfulness,
      startTime: yesterday.subtract(const Duration(hours: 8)),
      endTime: yesterday.subtract(const Duration(hours: 7, minutes: 50)),
      durationInMinutes: 10,
      isCompleted: true,
      imageUrl: 'https://via.placeholder.com/400x200',
    );

    final session2 = MeditationSession(
      id: '2',
      userId: _currentUserId,
      title: 'Deep Breathing',
      category: AppConstants.breathingExercises,
      startTime: twoDaysAgo.subtract(const Duration(hours: 12)),
      endTime: twoDaysAgo.subtract(const Duration(hours: 11, minutes: 55)),
      durationInMinutes: 5,
      isCompleted: true,
      imageUrl: 'https://via.placeholder.com/400x200',
    );

    final session3 = MeditationSession(
      id: '3',
      userId: _currentUserId,
      title: 'Sleep Story: Ocean Waves',
      category: AppConstants.sleepStories,
      startTime: threeDaysAgo.subtract(const Duration(hours: 22)),
      endTime: threeDaysAgo.subtract(const Duration(hours: 21, minutes: 40)),
      durationInMinutes: 20,
      isCompleted: true,
      imageUrl: 'https://via.placeholder.com/400x200',
    );

    _sessions.addAll([session1, session2, session3]);
    _sessionsController.add(List.from(_sessions));

    // Create initial summary
    _currentUserSummary = MeditationSummary(
      userId: _currentUserId,
      date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      totalMinutes: 0,
      sessionsCompleted: 0,
      categoryMinutes: {},
      currentStreak: 3, // Assuming user has meditated for the last 3 days
    );
    _summaryController.add(_currentUserSummary);
  }

  // Dispose method to close stream controllers
  void dispose() {
    _sessionsController.close();
    _programsController.close();
    _summaryController.close();
    _activeSessionController.close();
    if (_sessionTimer != null) {
      _sessionTimer!.cancel();
    }
  }
}