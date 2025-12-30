import 'package:get_me_a_tutor/import_export.dart';

class JobApplicationProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<JobApplicationModel> _recentApplications = [];

  final JobApplicationService _service = JobApplicationService();

  bool get isLoading => _isLoading;
  List<JobApplicationModel> get recentApplications => _recentApplications;

  Future<void> fetchRecentApplications(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.token == null) return;

    _isLoading = true;
    notifyListeners();

    _recentApplications = await _service.fetchRecentApplications(
      context: context,
      token: authProvider.token!,
    );

    _isLoading = false;
    notifyListeners();
  }

  final JobApplicationService _services =
  JobApplicationService();

  List<JobApplicationModel> _applications = [];

  List<JobApplicationModel> get applications => _applications;

  Future<void> fetchApplications({
    required BuildContext context,
    required String jobId,
  }) async {
    final authProvider =
    Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.token == null) return;

    _isLoading = true;
    notifyListeners();

    _applications = await _services.getApplicationsForJob(
      context: context,
      token: authProvider.token!,
      jobId: jobId,
    );

    _isLoading = false;
    notifyListeners();
  }
  Future<bool> applyToJob({
    required BuildContext context,
    required String jobId,
    String? message,
  }) async {
    final authProvider =
    Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.token == null) {
      showSnackBar(context, 'Not authenticated');
      return false;
    }

    _isLoading = true;
    notifyListeners();

    final success = await _service.applyToJob(
      context: context,
      token: authProvider.token!,
      jobId: jobId,
      message: message,
    );

    _isLoading = false;
    notifyListeners();

    return success;
  }
  Future<bool> updateApplicationStatus({
    required BuildContext context,
    required String applicationId,
    required String status,
  }) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    _isLoading = true;
    notifyListeners();

    final success = await _service.updateApplicationStatus(
      context: context,
      token: auth.token!,
      applicationId: applicationId,
      status: status,
    );

    if (success) {
      // 🔥 Update applications list (All Applications screen)
      final appIndex =
      _applications.indexWhere((a) => a.id == applicationId);
      if (appIndex != -1) {
        _applications[appIndex] =
            _applications[appIndex].copyWith(status: status);
      }

      // 🔥 Update recent applications list (Dashboard)
      final recentIndex =
      _recentApplications.indexWhere((a) => a.id == applicationId);
      if (recentIndex != -1) {
        _recentApplications[recentIndex] =
            _recentApplications[recentIndex].copyWith(status: status);
      }
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }



}
