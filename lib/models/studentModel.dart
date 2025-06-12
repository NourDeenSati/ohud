


class StudentModel {
  final int id;
  final String name;
  final String tokenId;
  // أضف بقية الخصائص حسب الحاجة

  StudentModel({
    required this.id,
    required this.name,
    required this.tokenId
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      name: json['name'],
      tokenId: json['qr_token']
    );
  }
}

class CircleWithStudentsModel {
  final String circleName;
  final List<StudentModel> students;

  CircleWithStudentsModel({
    required this.circleName,
    required this.students,
  });

  factory CircleWithStudentsModel.fromJson(Map<String, dynamic> json) {
    return CircleWithStudentsModel(
      circleName: json['circle'],
      students: (json['students'] as List)
          .map((studentJson) => StudentModel.fromJson(studentJson))
          .toList(),
    );
  }
}
