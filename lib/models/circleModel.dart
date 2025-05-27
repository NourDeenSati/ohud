class CircleWithStudentsModel {
  final String circleName;
  final Map<int, String> students;

  CircleWithStudentsModel({required this.circleName, required this.students});

  factory CircleWithStudentsModel.fromJson(Map<String, dynamic> json) {
    final studentsMap = <int, String>{};

    if (json['students'] != null) {
      if (json['students'] is Map) {
        // إذا كانت students خريطة (Map)
        json['students'].forEach((key, value) {
          studentsMap[int.parse(key)] = value.toString();
        });
      } else if (json['students'] is List) {
        // إذا كانت students مصفوفة (List)
        for (int i = 0; i < json['students'].length; i++) {
          studentsMap[i] = json['students'][i].toString();
        }
      }
    }

    return CircleWithStudentsModel(
      circleName: json['circle'] ?? '',
      students: studentsMap,
    );
  }
}
