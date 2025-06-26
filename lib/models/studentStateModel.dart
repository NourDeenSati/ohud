class StudentStatsModel {
  final int gainThisWeek;
  final int gainLastWeek;
  final double improvementPercent;
  final int circleNow;
  final int circlePrev;
  final int mosqueNow;
  final int mosquePrev;

  StudentStatsModel({
    required this.gainThisWeek,
    required this.gainLastWeek,
    required this.improvementPercent,
    required this.circleNow,
    required this.circlePrev,
    required this.mosqueNow,
    required this.mosquePrev,
  });

  factory StudentStatsModel.fromResponses({
    required Map<String, dynamic> weeklyJson,
    required Map<String, dynamic> rankingsJson,
  }) {
    return StudentStatsModel(
      gainThisWeek: (weeklyJson['gain_this_week'] as num).toInt(),
      gainLastWeek: (weeklyJson['gain_last_week'] as num).toInt(),
      improvementPercent: (weeklyJson['improvementPercent'] as num).toDouble(),
      circleNow: (rankingsJson['circle']['now'] as num).toInt(),
      circlePrev: (rankingsJson['circle']['prev'] as num).toInt(),
      mosqueNow: (rankingsJson['mosque']['now'] as num).toInt(),
      mosquePrev: (rankingsJson['mosque']['prev'] as num).toInt(),
    );
  }
}
