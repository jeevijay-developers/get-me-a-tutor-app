import 'package:http/http.dart' as http;
import 'package:get_me_a_tutor/import_export.dart';

class AuthServices {
//signUp
  Future<Map<String, dynamic>?> signUp({
    required BuildContext context,
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${GlobalVariables.baseUrl}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'role': role.toLowerCase(),
        }),
      );

      Map<String, dynamic>? result;

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          final data = jsonDecode(response.body);
          showSnackBar(context, data['message']);
          result = data;
        },
      );

      return result;
    } catch (e) {
      showSnackBar(context, 'Error: ${e.toString()}');
      print(e.toString());
      return null;
    }
  }

  //otp verify
  Future<Map<String, dynamic>?> verifyEmailOtp({
    required BuildContext context,
    required String email,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${GlobalVariables.baseUrl}/auth/verify-email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'otp': otp,
        }),
      );

      Map<String, dynamic>? result;

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          final data = jsonDecode(response.body);
          showSnackBar(context, data['message']);
          result = data;
        },
      );

      return result;
    } catch (e) {
      showSnackBar(context, 'Error: ${e.toString()}');
      print(e.toString());
      return null;
    }
  }

  //login
  Future<Map<String, dynamic>?> login({
    required BuildContext context,
    required String identifier,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${GlobalVariables.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identifier': identifier,
          'password': password,
        }),
      );

      Map<String, dynamic>? result;

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          final data = jsonDecode(response.body);
          showSnackBar(context, data['message']);
          result = data;
        },
      );

      return result;
    } catch (e) {
      showSnackBar(context, 'Error: ${e.toString()}');
      return null;
    }
  }
}