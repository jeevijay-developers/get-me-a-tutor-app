import 'package:get_me_a_tutor/import_export.dart';
import 'package:http/http.dart' as http;

class TeacherServices {
  Future<TeacherModel?> fetchTeacherProfile({
    required BuildContext context,
    required String userId,
  }) async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);

      if (auth.userId == null) {
        showSnackBar(context, 'User not logged in');
        return null;
      }

      final response = await http.get(
        Uri.parse(
          '${GlobalVariables.baseUrl}/profile/teacher/${userId}',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${auth.token}',
        },
      );

      TeacherModel? teacher;

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          final data = jsonDecode(response.body);

          // backend returns { profile, owner }
          teacher = TeacherModel.fromJson(data['profile']);
        },
      );

      return teacher;
    } catch (e) {
      showSnackBar(context, e.toString());
      return null;
    }
  }
}
