part of '../../main.dart';

class AuthSession {
  final String id;
  final String email;
  final String token;

  AuthSession({
    required this.id,
    required this.email,
    required this.token,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      token: json['token'] as String? ?? '',
    );
  }
}

class ApiClient {
  static String? _baseUrl;
  static AuthSession? _session;

  static String get baseUrl {
    if (_baseUrl == null) {
      throw StateError('ApiClient has not been initialized. Call initialize() first.');
    }
    return _baseUrl!;
  }

  static AuthSession? get session => _session;

  static void setSession(AuthSession? session) {
    _session = session;
  }

  static Future<void> initialize() async {
    try {
      final envString = await rootBundle.loadString('.env');
      final lines = envString.split(RegExp(r'\r?\n'));
      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
        final parts = trimmed.split('=');
        if (parts.length >= 2) {
          final key = parts[0].trim();
          final value = parts.sublist(1).join('=').trim();
          if (key == 'API_BASE_URL') {
            _baseUrl = value;
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading .env file: $e');
    }
    // Fallback if not loaded
    _baseUrl ??= 'https://1617-103-112-11-19.ngrok-free.app';
  }

  static Future<Map<String, dynamic>> register(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> verifyEmail(String email, String code) async {
    final url = Uri.parse('$baseUrl/api/auth/verify-email');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> resendOtp(String email) async {
    final url = Uri.parse('$baseUrl/api/auth/resend-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> loginOtp(String email) async {
    final url = Uri.parse('$baseUrl/api/auth/login-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> verifyLoginOtp(String email, String code) async {
    final url = Uri.parse('$baseUrl/api/auth/verify-login-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
    );
    return _handleResponse(response);
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw Exception('Server returned invalid JSON response: ${response.statusCode}');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      final message = body['message'] as String? ?? 'An error occurred';
      throw ApiException(message, response.statusCode);
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}
