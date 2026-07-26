class ApiConstants {

  // Replace with your live Render server URL once deployed (e.g., https://ka-app-backend.onrender.com/api/v1)
  static const String baseUrl = "https://ka-app-backend.onrender.com/api/v1";

  // Local development base URL (10.0.2.2 for Android Emulator, localhost for iOS/Web)
  // static const String baseUrl = "http://10.0.2.2:8000/api/v1";

  static const String login = "$baseUrl/auth/login";
  static const String submit = "$baseUrl/queries";
  static const String createUser = "$baseUrl/users";
  static const String queries = "$baseUrl/queries";
  static const String generateToken = "$baseUrl/tokens/generate";
  static const String meta = "$baseUrl/meta/options";

}