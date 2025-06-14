class APIEndpoints {
  static final String baseUrl = 'http://159.65.119.170/api/';
  static _AuthEndPoint authEndPoint = _AuthEndPoint();
  static _TeacherPoints teacherPoints = _TeacherPoints();
  static _AttendanceEndPoint attendanceEndPoint = _AttendanceEndPoint();
  static _notesEndPoint notesEndPoint = _notesEndPoint();
  static _MushafEndPoints mushafEndPoints = _MushafEndPoints();
}

class _AuthEndPoint {
  final String login = 'teacher/login';
  final String logout = 'teacher/logout';

}

class _TeacherPoints {
  final String students = 'teacher/circle/students';
  final String data = 'teacher/circle/info';
  final String Archive = 'teacher/history';
}

class _AttendanceEndPoint {
  final String submit = 'teacher/attendance/register';
  final String abs =
      'teacher/attendance/justify';
}

class _MushafEndPoints {
  String getDetails({required String studentId, required int pageNumber}) =>
      'teacher/recitation/check?student_id=$studentId&page=$pageNumber';
  final String saveNotes =
      'teacher/recitation/store';
}

class _notesEndPoint {
  final String submit = 'teacher/note/create';
}
