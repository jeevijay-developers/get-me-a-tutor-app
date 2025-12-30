import 'package:get_me_a_tutor/import_export.dart';
import 'package:http/http.dart' as http;

class ParentProfileServices {
  Future<ParentModel?> createParentProfile({
    required BuildContext context,
    required String token,
    required Map<String, dynamic> body,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${GlobalVariables.baseUrl}/api/parent'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      ParentModel? parent;

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final data = jsonDecode(res.body);
          parent = ParentModel.fromJson(data['parent']);
        },
      );

      return parent;
    } catch (e) {
      showSnackBar(context, e.toString());
      return null;
    }
  }

  Future<ParentModel?> getMyParentProfile({
    required BuildContext context,
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse('${GlobalVariables.baseUrl}/api/parent/my'),
        headers: {'Authorization': 'Bearer $token'},
      );

      ParentModel? parent;

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final data = jsonDecode(res.body);
          parent = ParentModel.fromJson(data['parent']);
        },
      );

      return parent;
    } catch (e) {
      showSnackBar(context, e.toString());
      return null;
    }
  }
  Future<ParentModel?> updateParentProfile({
    required BuildContext context,
    required String token,
    required Map<String, dynamic> body,
  }) async {
    try {
      final res = await http.put(
        Uri.parse('${GlobalVariables.baseUrl}/api/parent'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      ParentModel? parent;

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final data = jsonDecode(res.body);
          parent = ParentModel.fromJson(data['parent']);
        },
      );

      return parent;
    } catch (e) {
      showSnackBar(context, e.toString());
      return null;
    }
  }

}
