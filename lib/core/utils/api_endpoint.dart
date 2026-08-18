class ApiEndpoint {
  ApiEndpoint._();

  static const String baseUrl = 'https://cr-assistant-backend-1.onrender.com/api'; // Android Emulator: 'http://10.0.2.2:3000/api'

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';

  // Semester / Subject / Resource
  static const String semesters = '/semesters';
  static String subjects(int semesterId) => '/semesters/$semesterId/subjects';
  static String addSubject(int semesterId) => '/semesters/$semesterId/subjects';
  static String resources(int subjectId) => '/subjects/$subjectId/resources';
  static String uploadResource(int subjectId) => '/subjects/$subjectId/resources';

  // Chat
  static const String chatHistory = '/chat/history';
  static const String chatSend = '/chat/send';
}
