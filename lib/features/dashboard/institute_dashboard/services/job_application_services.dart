import 'package:http/http.dart' as http;
import 'package:get_me_a_tutor/import_export.dart';

class JobApplicationService {
  Future<List<JobApplicationModel>> fetchRecentApplications({
    required BuildContext context,
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse('${GlobalVariables.baseUrl}/applications/institute/recent'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      List<JobApplicationModel> applications = [];

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final data = jsonDecode(res.body);
          applications = (data['applications'] as List)
              .map((e) => JobApplicationModel.fromJson(e))
              .toList();
        },
      );

      return applications;
    } catch (e) {
      showSnackBar(context, e.toString());
      return [];
    }
  }

  Future<List<JobApplicationModel>> getApplicationsForJob({
    required BuildContext context,
    required String token,
    required String jobId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${GlobalVariables.baseUrl}/applications/job/$jobId',
        ),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      List<JobApplicationModel> applications = [];

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          final data = jsonDecode(response.body);
          applications = (data['applications'] as List)
              .map((e) => JobApplicationModel.fromJson(e))
              .toList();
        },
      );

      return applications;
    } catch (e) {
      showSnackBar(context, e.toString());
      return [];
    }
  }
  Future<bool> applyToJob({
    required BuildContext context,
    required String token,
    required String jobId,
    String? message,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${GlobalVariables.baseUrl}/applications/apply'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'jobId': jobId,
          'message': message ?? '',
        }),
      );

      bool success = false;

      httpErrorHandle(
        response: res,
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
  Future<bool> updateApplicationStatus({
    required BuildContext context,
    required String token,
    required String applicationId,
    required String status,
  }) async {
    try {
      final res = await http.patch(
        Uri.parse(
          '${GlobalVariables.baseUrl}/applications/$applicationId/status',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': status}),
      );

      bool success = false;

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final data = jsonDecode(res.body);
          print('UPDATED APPLICATION FROM API: ${data['application']}');
          success = true;
        },
      );

      return success;
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }
  Future<List<TutorAppliedJobModel>> fetchMyApplications({
    required BuildContext context,
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse('${GlobalVariables.baseUrl}/applications/my'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      List<TutorAppliedJobModel> applications = [];

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final data = jsonDecode(res.body);
          applications = (data['applications'] as List)
              .map((e) => TutorAppliedJobModel.fromJson(e))
              .toList();
        },
      );

      return applications;
    } catch (e) {
      showSnackBar(context, e.toString());
      return [];
    }
  }

}
