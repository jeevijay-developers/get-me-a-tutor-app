import 'package:get_me_a_tutor/import_export.dart';
import 'package:http/http.dart' as http;

class TutorSearchServices {
  Future<List<TutorSearchModel>> searchTeachers({
    required BuildContext context,
    String? q,
  }) async {
    try {
      final uri = Uri.parse(
        '${GlobalVariables.baseUrl}/search/teachers',
      ).replace(
        queryParameters: {
          if (q != null && q.isNotEmpty) 'q': q,
        },
      );

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      List<TutorSearchModel> tutors = [];

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          final data = jsonDecode(response.body);
          tutors = (data['teachers'] as List)
              .map((e) => TutorSearchModel.fromJson(e))
              .where((t) => t.isPublic) // ✅ IMPORTANT
              .toList();
        },
      );

      return tutors;
    } catch (e) {
      showSnackBar(context, e.toString());
      return [];
    }
  }
}
