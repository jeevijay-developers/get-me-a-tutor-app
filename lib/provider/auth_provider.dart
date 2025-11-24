import 'package:get_me_a_tutor/import_export.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _token;
  String? _tempEmail;
  final AuthServices _authServices = AuthServices();

  bool get isLoading => _isLoading;
  String? get token => _token;
  bool get isLoggedIn => _token != null;
  String? get tempEmail => _tempEmail;

  AuthProvider() {
    _loadToken();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Load token from SharedPreferences
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('authToken');
    notifyListeners();
  }

//sign up
  Future<bool> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
    required BuildContext context,
  }) async {
    setLoading(true);

    final result = await _authServices.signUp(
      context: context,
      name: name,
      email: email,
      phone: phone,
      password: password,
      role: role,
    );

    setLoading(false);

    if (result != null) {
      _tempEmail = email; // Store for OTP verification screen
      notifyListeners();
      return true;
    }
    return false;
  }

  // verify otp
  Future<bool> verifyEmailOtp({
    required String otp,
    required BuildContext context,
  }) async {
    if (_tempEmail == null) return false;

    setLoading(true);

    final result = await _authServices.verifyEmailOtp(
      context: context,
      email: _tempEmail!,
      otp: otp,
    );

    setLoading(false);

    return result != null; // true if success
  }

  // Login
  Future<bool> login({
    required String identifier,
    required String password,
    required BuildContext context,
  }) async {
    setLoading(true);
    final result = await _authServices.login(
      context: context,
      identifier: identifier,
      password: password,
    );
    setLoading(false);

    if (result != null && result['token'] != null) {
      _token = result['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', _token!);
      notifyListeners();
      return true;
    }
    return false;
  }
}