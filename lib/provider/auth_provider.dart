import 'package:get_me_a_tutor/import_export.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _accessToken;
  String? _tempEmail;
  String? _role;
  String? _email;
  String? _phone;
  String? _userId;
  String? _name;
  bool hasInstituteProfile = false;
  bool hasTeacherProfile = false;
  bool hasParentProfile = false;
  final AuthServices _authServices = AuthServices();
  bool get isLoading => _isLoading;
  String? get token => _accessToken;
  String? get role => _role;
  String? get name => _name;
  String? get userId => _userId;
  String? get email => _email;
  String? get phone => _phone;
  bool get isLoggedIn => _accessToken != null;
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
    _accessToken = prefs.getString('authToken');
    _role = prefs.getString('userRole');
    _userId = prefs.getString('userId');
    _email = prefs.getString('email');
    _phone = prefs.getString('phone');
    _name = prefs.getString('name');
    if (_userId != null) {
      hasInstituteProfile =
          prefs.getBool('hasInstituteProfile_$_userId') ?? false;
      hasTeacherProfile =
          prefs.getBool('hasTeacherProfile_$_userId') ?? false;
      hasParentProfile = prefs.getBool('hasParentProfile$_userId') ?? false;
    }
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
  Future<String?> verifyEmailOtp({
    required String otp,
    required BuildContext context,
  }) async {
    if (_tempEmail == null) return null;

    setLoading(true);

    final result = await _authServices.verifyEmailOtp(
      context: context,
      email: _tempEmail!,
      otp: otp,
    );

    setLoading(false);

    if (result != null &&
        result['accessToken'] != null &&
        result['user'] != null) {
      _accessToken = result['accessToken'];
      _role = result['user']['role'].toString().toLowerCase();
      _userId = result['user']['id'];
      _email = result['user']['email'];
      _phone = result['user']['phone'];
      _name = result['user']['name'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', _accessToken!);
      await prefs.setString('userRole', _role!);
      await prefs.setString('userId', _userId!);
      await prefs.setString('email', _email!);
      await prefs.setString('name', _name!);
      await prefs.setString('phone', _phone!);
      _tempEmail = null;
      notifyListeners();
      return _role;
    }
    return null;
  }

  // Login
  Future<String?> login({
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

    if (result != null &&
        result['accessToken'] != null &&
        result['user'] != null) {
      _accessToken = result['accessToken'];
      _role = result['user']['role'];
      _name = result['user']['name'];
      _userId = result['user']['id'];
      _email = result['user']['email'];
      _phone = result['user']['phone'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', _userId!);
      await prefs.setString('email', _email!);
      await prefs.setString('phone', _phone!);
      await prefs.setString('name', _name!);
      await prefs.setString('authToken', _accessToken!);
      await prefs.setString('userRole', _role!);

      notifyListeners();
      return _role;
    }
    return null;
  }

  // resend email otp
  Future<bool> resendEmailOtp({required BuildContext context}) async {
    setLoading(true);

    final result = await _authServices.resendEmailOtp(
      context: context,
      email: _tempEmail!,
    );

    setLoading(false);

    if (result != null) {
      return true;
    }
    return false;
  }

  // forgot password
  Future<bool> forgotPassword({
    required String email,
    required BuildContext context,
  }) async {
    setLoading(true);

    final result = await _authServices.forgotPassword(
      context: context,
      email: email,
    );

    setLoading(false);

    return result != null;
  }

  Future<void> logout({required BuildContext context}) async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');

    if (refreshToken != null) {
      await _authServices.logout(context: context, refreshToken: refreshToken);
    }

    // clear local state
    _accessToken = null;
    _role = null;
    _email = null;
    _phone = null;
    _tempEmail = null;
    _name = null;
    _userId = null;
    await prefs.remove('authToken');
    await prefs.remove('userRole');
    await prefs.remove('userId');
    await prefs.remove('name');
    await prefs.remove('refreshToken');
    notifyListeners();
  }

  Future<bool> resetPassword({
    required BuildContext context,
    required String email,
    required String token,
    required String newPassword,
  }) async {
    setLoading(true);

    final success = await _authServices.resetPassword(
      context: context,
      email: email,
      token: token,
      newPassword: newPassword,
    );

    setLoading(false);
    return success;
  }

  //delete account
  Future<bool> deleteAccount({required BuildContext context}) async {
    if (_accessToken == null) {
      showSnackBar(context, 'Not authenticated');
      return false;
    }

    setLoading(true);

    final success = await _authServices.deleteAccount(
      context: context,
      token: _accessToken!,
    );

    setLoading(false);

    if (success) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _accessToken = null;
      _role = null;
      _email = null;
      _phone = null;
      _tempEmail = null;
      _name = null;
      _userId = null;
      hasInstituteProfile = false;
      hasTeacherProfile = false;
      hasParentProfile = false;
      notifyListeners();
    }
    return success;
  }

  Future<void> setHasInstituteProfile(bool value) async {
    if (_userId == null) return;
    hasInstituteProfile = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasInstituteProfile_$_userId', value);
    notifyListeners();
  }

  Future<void> setHasTeacherProfile(bool value) async {
    if (_userId == null) return;
    hasTeacherProfile = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasTeacherProfile_$_userId', value);
    notifyListeners();
  }
  Future<void> setHasParentProfile(bool value) async {
    if (_userId == null) return;
    hasParentProfile = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasParentProfile$_userId', value);
    notifyListeners();
  }
}
