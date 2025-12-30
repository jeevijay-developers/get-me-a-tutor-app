import 'package:get_me_a_tutor/import_export.dart';
import 'package:http/http.dart' as http;

class JobServices {
  // CREATE JOB
  Future<bool> createJob({
    required BuildContext context,
    required String token,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${GlobalVariables.baseUrl}/jobs'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      bool success = false;

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          success = true;
          showSnackBar(context, 'Job posted successfully');
        },
      );

      return success;
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }

  Future<List<JobModel>> getMyJobs({
    required BuildContext context,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${GlobalVariables.baseUrl}/jobs/my'),
        headers: {'Authorization': 'Bearer $token'},
      );

      List<JobModel> jobs = [];

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          final data = jsonDecode(response.body);
          jobs = (data['jobs'] as List)
              .map((e) => JobModel.fromJson(e))
              .toList();
        },
      );

      return jobs;
    } catch (e) {
      showSnackBar(context, e.toString());
      return [];
    }
  }

  // CLOSE JOB
  Future<bool> closeJob({
    required BuildContext context,
    required String token,
    required String jobId,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('${GlobalVariables.baseUrl}/jobs/$jobId/close'),
        headers: {'Authorization': 'Bearer $token'},
      );

      bool success = false;

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          success = true;
          showSnackBar(context, 'Job closed successfully');
        },
      );

      return success;
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }

  // UPDATE JOB
  Future<bool> updateJob({
    required BuildContext context,
    required String token,
    required String jobId,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${GlobalVariables.baseUrl}/jobs/$jobId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      bool success = false;

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          success = true;
          showSnackBar(context, 'Job updated successfully');
        },
      );

      return success;
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }

  Future<List<JobModel>> getTutorJobs({
    required BuildContext context,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${GlobalVariables.baseUrl}/jobs'),
        headers: {if (token.isNotEmpty) 'Authorization': 'Bearer $token'},
      );

      List<JobModel> jobs = [];

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          final data = jsonDecode(response.body);
          jobs = (data['jobs'] as List)
              .map((e) => JobModel.fromJson(e))
              .toList();
        },
      );

      return jobs;
    } catch (e) {
      showSnackBar(context, e.toString());
      return [];
    }
  }
}
