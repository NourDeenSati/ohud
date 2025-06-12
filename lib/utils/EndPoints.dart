class APIEndpoints {
  static final String baseUrl = 'http://192.168.6.41:8000/api/';
  static _AuthEndPoint authEndPoint = _AuthEndPoint();
  static _TeacherPoints teacherPoints = _TeacherPoints();
  static _AttendanceEndPoint attendanceEndPoint = _AttendanceEndPoint(); // جديد
  static _notesEndPoint notesEndPoint = _notesEndPoint();
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
  final String abs = 'teacher/attendance/justify'; // ← هذا المسار هو المستعمل للتسجيل
}
 
class _notesEndPoint{
  final String submit = 'teacher/note/create';

}