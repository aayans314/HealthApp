import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class WaterIntakeTracker extends StatelessWidget {
  final bool compact;

  const WaterIntakeTracker({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: compact ? 2 : 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(compact ? 12.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppConstants.waterIntake,
                  style: compact
                      ? Theme.of(context).textTheme.titleMedium
                      : Theme.of(context).textTheme.titleLarge,
                ),
                if (!compact)
                  Text(
                    'May 15, 2023',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
            SizedBox(height: compact ? 12 : 16),
            _buildWaterProgress(context),
            SizedBox(height: compact ? 12 : 16),
            if (!compact) _buildWaterIntakeHistory(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterProgress(BuildContext context) {
    // Mock data: 6 glasses out of 8 recommended
    const currentIntake = 6;
    const targetIntake = 8;
    const progress = currentIntake / targetIntake;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$currentIntake of $targetIntake glasses',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                      fontSize: compact ? 14 : 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(currentIntake * 250).toString()} ml of ${(targetIntake * 250).toString()} ml',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: compact ? 12 : 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppTheme.secondaryColor.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.secondaryColor),
                    minHeight: compact ? 8 : 10,
                    borderRadius: BorderRadius.circular(compact ? 4 : 5),
                  ),
                ],
              ),
            ),
            if (!compact) const SizedBox(width: 16),
            if (!compact)
              Expanded(
                flex: 1,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.water_drop,
                        color: AppTheme.secondaryColor,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '+ 250 ml',
                        style: TextStyle(
                          color: AppTheme.secondaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        if (compact)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(targetIntake - currentIntake)} more to go',
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    color: AppTheme.secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildWaterIntakeHistory(BuildContext context) {
    // Mock data for water intake throughout the day
    final intakeHistory = [
      {'time': '08:00 AM', 'amount': '250 ml'},
      {'time': '10:30 AM', 'amount': '250 ml'},
      {'time': '12:45 PM', 'amount': '250 ml'},
      {'time': '03:15 PM', 'amount': '250 ml'},
      {'time': '05:00 PM', 'amount': '250 ml'},
      {'time': '07:30 PM', 'amount': '250 ml'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Intake',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: intakeHistory.length,
          itemBuilder: (context, index) {
            final intake = intakeHistory[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppTheme.textSecondaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        intake['time'] as String,
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.water_drop,
                        size: 16,
                        color: AppTheme.secondaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        intake['amount'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}