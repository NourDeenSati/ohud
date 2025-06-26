class APIEndpoints {
  static final String baseUrl = 'http://159.65.119.170/api/';
  static _AuthEndPoint authEndPoint = _AuthEndPoint();
  static _TeacherPoints teacherPoints = _TeacherPoints();
  static _StudentPoints studentPoints = _StudentPoints();

  static _AttendanceEndPoint attendanceEndPoint = _AttendanceEndPoint(); // جديد
  static _notesEndPoint notesEndPoint = _notesEndPoint();
}

class _AuthEndPoint {
  final String login = 'student/login';
  final String logout = 'student/logout';
}

class _TeacherPoints {
  final String students = 'teacher/circle/students';
  final String data = 'teacher/circle/info';
  final String Archive = 'teacher/history';
}

class _StudentPoints {
  final String studentDetailes = 'student/info';
}

class _AttendanceEndPoint {
  final String submit = 'teacher/attendance/register';
  final String abs =
      'teacher/attendance/justify'; // ← هذا المسار هو المستعمل للتسجيل
}

class _notesEndPoint {
  final String submit = 'teacher/note/create';
}
