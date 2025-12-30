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

// resend email otp
  Future<Map<String, dynamic>?> resendEmailOtp({
    required BuildContext context,
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${GlobalVariables.baseUrl}/auth/resend-email-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
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

  // forgot password (send reset link)
  Future<Map<String, dynamic>?> forgotPassword({
    required BuildContext context,
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${GlobalVariables.baseUrl}/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
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
// LOGOUT
  Future<bool> logout({
    required BuildContext context,
    required String refreshToken,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${GlobalVariables.baseUrl}/auth/logout'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'refreshToken': refreshToken,
        }),
      );

      bool success = false;

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          success = true;
        },
      );

      return success;
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }
// RESET PASSWORD
  Future<bool> resetPassword({
    required BuildContext context,
    required String email,
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${GlobalVariables.baseUrl}/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'token': token,
          'newPassword': newPassword,
        }),
      );

      bool success = false;

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          final data = jsonDecode(response.body);
          showSnackBar(context, data['message']);
          success = true;
        },
      );

      return success;
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }
  //delete account
  Future<bool> deleteAccount({
    required BuildContext context,
    required String token,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('${GlobalVariables.baseUrl}/auth/delete-account'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      bool success = false;

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          final data = jsonDecode(response.body);
          showSnackBar(context, data['message']);
          success = true;
        },
      );

      return success;
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }


}