class Meal {
  final String id;
  final String userId;
  final String name;
  final String type; // e.g., 'breakfast', 'lunch', 'dinner', 'snack'
  final DateTime dateTime;
  final List<FoodItem> foodItems;
  final int totalCalories;
  final double totalProtein; // in grams
  final double totalCarbs; // in grams
  final double totalFat; // in grams
  final String? notes;
  final String? imageUrl;

  Meal({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.dateTime,
    required this.foodItems,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    this.notes,
    this.imageUrl,
  });

  // Create a copy of the meal with updated fields
  Meal copyWith({
    String? id,
    String? userId,
    String? name,
    String? type,
    DateTime? dateTime,
    List<FoodItem>? foodItems,
    int? totalCalories,
    double? totalProtein,
    double? totalCarbs,
    double? totalFat,
    String? notes,
    String? imageUrl,
  }) {
    return Meal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      dateTime: dateTime ?? this.dateTime,
      foodItems: foodItems ?? this.foodItems,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProtein: totalProtein ?? this.totalProtein,
      totalCarbs: totalCarbs ?? this.totalCarbs,
      totalFat: totalFat ?? this.totalFat,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // Calculate nutritional totals from food items
  factory Meal.calculateFromFoodItems({
    required String id,
    required String userId,
    required String name,
    required String type,
    required DateTime dateTime,
    required List<FoodItem> foodItems,
    String? notes,
    String? imageUrl,
  }) {
    int totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    for (final foodItem in foodItems) {
      totalCalories += foodItem.calories;
      totalProtein += foodItem.protein;
      totalCarbs += foodItem.carbs;
      totalFat += foodItem.fat;
    }

    return Meal(
      id: id,
      userId: userId,
      name: name,
      type: type,
      dateTime: dateTime,
      foodItems: foodItems,
      totalCalories: totalCalories,
      totalProtein: totalProtein,
      totalCarbs: totalCarbs,
      totalFat: totalFat,
      notes: notes,
      imageUrl: imageUrl,
    );
  }

  // Convert meal to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'type': type,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'foodItems': foodItems.map((item) => item.toMap()).toList(),
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFat': totalFat,
      'notes': notes,
      'imageUrl': imageUrl,
    };
  }

  // Create a meal from a map
  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      dateTime: map['dateTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateTime'])
          : DateTime.now(),
      foodItems: map['foodItems'] != null
          ? List<FoodItem>.from(
              map['foodItems']?.map((x) => FoodItem.fromMap(x)))
          : [],
      totalCalories: map['totalCalories'] ?? 0,
      totalProtein: map['totalProtein'] ?? 0.0,
      totalCarbs: map['totalCarbs'] ?? 0.0,
      totalFat: map['totalFat'] ?? 0.0,
      notes: map['notes'],
      imageUrl: map['imageUrl'],
    );
  }
}

class FoodItem {
  final String id;
  final String name;
  final double servingSize; // in grams or milliliters
  final String servingUnit; // e.g., 'g', 'ml', 'oz', 'cup'
  final int calories;
  final double protein; // in grams
  final double carbs; // in grams
  final double fat; // in grams
  final double fiber; // in grams
  final double sugar; // in grams
  final String? barcode;
  final String? imageUrl;

  FoodItem({
    required this.id,
    required this.name,
    required this.servingSize,
    required this.servingUnit,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.sugar,
    this.barcode,
    this.imageUrl,
  });

  // Convert food item to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'servingSize': servingSize,
      'servingUnit': servingUnit,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
      'sugar': sugar,
      'barcode': barcode,
      'imageUrl': imageUrl,
    };
  }

  // Create a food item from a map
  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      servingSize: map['servingSize'] ?? 0.0,
      servingUnit: map['servingUnit'] ?? 'g',
      calories: map['calories'] ?? 0,
      protein: map['protein'] ?? 0.0,
      carbs: map['carbs'] ?? 0.0,
      fat: map['fat'] ?? 0.0,
      fiber: map['fiber'] ?? 0.0,
      sugar: map['sugar'] ?? 0.0,
      barcode: map['barcode'],
      imageUrl: map['imageUrl'],
    );
  }
}

class WaterIntake {
  final String id;
  final String userId;
  final DateTime dateTime;
  final double amount; // in milliliters

  WaterIntake({
    required this.id,
    required this.userId,
    required this.dateTime,
    required this.amount,
  });

  // Convert water intake to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'amount': amount,
    };
  }

  // Create a water intake from a map
  factory WaterIntake.fromMap(Map<String, dynamic> map) {
    return WaterIntake(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      dateTime: map['dateTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateTime'])
          : DateTime.now(),
      amount: map['amount'] ?? 0.0,
    );
  }
}

class NutritionSummary {
  final String userId;
  final DateTime date;
  final int totalCalories;
  final double totalProtein; // in grams
  final double totalCarbs; // in grams
  final double totalFat; // in grams
  final double totalWater; // in milliliters
  final Map<String, int> mealTypeCalories; // e.g., {'breakfast': 500, 'lunch': 700}

  NutritionSummary({
    required this.userId,
    required this.date,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.totalWater,
    required this.mealTypeCalories,
  });

  // Convert nutrition summary to a map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': date.millisecondsSinceEpoch,
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFat': totalFat,
      'totalWater': totalWater,
      'mealTypeCalories': mealTypeCalories,
    };
  }

  // Create a nutrition summary from a map
  factory NutritionSummary.fromMap(Map<String, dynamic> map) {
    return NutritionSummary(
      userId: map['userId'] ?? '',
      date: map['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['date'])
          : DateTime.now(),
      totalCalories: map['totalCalories'] ?? 0,
      totalProtein: map['totalProtein'] ?? 0.0,
      totalCarbs: map['totalCarbs'] ?? 0.0,
      totalFat: map['totalFat'] ?? 0.0,
      totalWater: map['totalWater'] ?? 0.0,
      mealTypeCalories: map['mealTypeCalories'] != null
          ? Map<String, int>.from(map['mealTypeCalories'])
          : {},
    );
  }

  // Check if daily water goal is achieved (default: 2000ml)
  bool isWaterGoalAchieved({double waterGoal = 2000}) {
    return totalWater >= waterGoal;
  }

  // Calculate water goal progress percentage
  double getWaterGoalProgress({double waterGoal = 2000}) {
    return (totalWater / waterGoal).clamp(0.0, 1.0);
  }

  // Calculate macronutrient percentages
  Map<String, double> getMacroPercentages() {
    final totalGrams = totalProtein + totalCarbs + totalFat;
    if (totalGrams <= 0) {
      return {'protein': 0, 'carbs': 0, 'fat': 0};
    }
    
    return {
      'protein': totalProtein / totalGrams,
      'carbs': totalCarbs / totalGrams,
      'fat': totalFat / totalGrams,
    };
  }
}