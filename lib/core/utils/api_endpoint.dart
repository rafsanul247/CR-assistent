class ApiEndpoint {
  ApiEndpoint._();

  static const String baseUrl = 'https://cr-assistant-backend-1.onrender.com/api'; 

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String myClassCode = '/auth/my-class-code';
  static const String fcmToken = '/auth/fcm-token';

  // Semester / Subject / Resource
  static const String semesters = '/semesters';
  static String subjects(int semesterId) => '/semesters/$semesterId/subjects';
  static String addSubject(int semesterId) => '/semesters/$semesterId/subjects';
  static String deleteSubject(int subjectId) => '/subjects/$subjectId';
  
  static String resources(int subjectId) => '/subjects/$subjectId/resources';
  static String uploadResource(int subjectId) => '/subjects/$subjectId/resources';
  static String deleteResource(int resourceId) => '/resources/$resourceId';

  // Notice
  static const String notices = '/notices';

  // Chat
  static const String chatHistory = '/chat/history';
  static const String chatSend = '/chat/send';
}
