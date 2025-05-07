class APIEndpoints{
  static final String baseUrl= 'http://192.168.23.41:8000';
  static _AuthEndPoint authEndPoint =_AuthEndPoint() ;
}
class _AuthEndPoint {
  final String login = '/api/teacher-login';
}
